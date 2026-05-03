@description('Short lowercase prefix for source environment resources.')
param prefix string

@description('Azure region for the source environment.')
param location string = resourceGroup().location

@description('Local administrator username for the source VM.')
param adminUsername string = 'azureuser'

@description('SSH public key for the source VM administrator account.')
param sshPublicKey string

@description('Git repository used to install eShopOnWeb on the source VM.')
param sourceRepoUrl string = 'https://github.com/dotnet-architecture/eShopOnWeb.git'

@description('Git branch used for the source VM eShopOnWeb installation.')
param sourceRepoBranch string = 'main'

var vnetName = '${prefix}-source-vnet'
var subnetName = 'source-vm'
var nsgName = '${prefix}-source-nsg'
var publicIpName = '${prefix}-source-pip'
var nicName = '${prefix}-source-nic'
var vmName = take('${prefix}-source-vm', 64)
var osDiskName = '${vmName}-osdisk'

var cloudInitTemplate = '''#cloud-config
package_update: true
packages:
  - git
  - curl
  - wget
  - apt-transport-https
  - ca-certificates
runcmd:
  - wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O /tmp/packages-microsoft-prod.deb
  - dpkg -i /tmp/packages-microsoft-prod.deb
  - apt-get update
  - apt-get install -y dotnet-sdk-8.0 aspnetcore-runtime-8.0
  - mkdir -p /opt/eshop
  - git clone --depth 1 --branch __SOURCE_REPO_BRANCH__ __SOURCE_REPO_URL__ /opt/eshop/eShopOnWeb
  - dotnet publish /opt/eshop/eShopOnWeb/src/Web/Web.csproj -c Release -o /opt/eshop/web
  - useradd --system --home /opt/eshop --shell /usr/sbin/nologin eshop || true
  - chown -R eshop:eshop /opt/eshop
  - |
    cat >/etc/systemd/system/eshop-web.service <<'EOF'
    [Unit]
    Description=eShopOnWeb monolith
    After=network-online.target
    Wants=network-online.target

    [Service]
    WorkingDirectory=/opt/eshop/web
    ExecStart=/usr/bin/dotnet /opt/eshop/web/Web.dll
    Restart=always
    RestartSec=10
    User=eshop
    AmbientCapabilities=CAP_NET_BIND_SERVICE
    CapabilityBoundingSet=CAP_NET_BIND_SERVICE
    Environment=ASPNETCORE_ENVIRONMENT=Development
    Environment=ASPNETCORE_URLS=http://0.0.0.0:80

    [Install]
    WantedBy=multi-user.target
    EOF
  - systemctl daemon-reload
  - systemctl enable eshop-web
  - systemctl start eshop-web
'''

var cloudInit = replace(replace(cloudInitTemplate, '__SOURCE_REPO_BRANCH__', sourceRepoBranch), '__SOURCE_REPO_URL__', sourceRepoUrl)

resource sourceNsg 'Microsoft.Network/networkSecurityGroups@2023-11-01' = {
  name: nsgName
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowHttp'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: 'Internet'
          destinationAddressPrefix: '*'
        }
      }
      {
        name: 'AllowSsh'
        properties: {
          priority: 110
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '22'
          sourceAddressPrefix: 'Internet'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

resource sourceVnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.10.0.0/16'
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: '10.10.1.0/24'
          networkSecurityGroup: {
            id: sourceNsg.id
          }
        }
      }
    ]
  }
}

resource publicIp 'Microsoft.Network/publicIPAddresses@2023-11-01' = {
  name: publicIpName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2023-11-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: sourceVnet.properties.subnets[0].id
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIp.id
          }
        }
      }
    ]
  }
}

resource sourceVm 'Microsoft.Compute/virtualMachines@2024-03-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2s'
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      customData: base64(cloudInit)
      linuxConfiguration: {
        disablePasswordAuthentication: true
        ssh: {
          publicKeys: [
            {
              path: '/home/${adminUsername}/.ssh/authorized_keys'
              keyData: sshPublicKey
            }
          ]
        }
      }
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-jammy'
        sku: '22_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        name: osDiskName
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
  }
}

output sourceVnetName string = sourceVnet.name
output sourceVmName string = sourceVm.name
output sourcePublicIp string = publicIp.properties.ipAddress
output sourceAppUrl string = 'http://${publicIp.properties.ipAddress}'
output sshCommand string = 'ssh ${adminUsername}@${publicIp.properties.ipAddress}'
