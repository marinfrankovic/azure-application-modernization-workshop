@description('Short lowercase prefix for source environment resources.')
param prefix string

@description('Azure region for the source environment.')
param location string = resourceGroup().location

@description('Container image used for the prepared eShopOnWeb source workload.')
param sourceImage string = 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'

var workspaceName = '${prefix}-source-law'
var vnetName = '${prefix}-source-vnet'
var environmentName = '${prefix}-source-cae'
var appName = '${prefix}-source-eshop'

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: workspaceName
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
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
        name: 'containerapps'
        properties: {
          addressPrefix: '10.10.0.0/23'
          delegations: [
            {
              name: 'containerapps-delegation'
              properties: {
                serviceName: 'Microsoft.App/environments'
              }
            }
          ]
        }
      }
    ]
  }
}

resource sourceEnvironment 'Microsoft.App/managedEnvironments@2023-05-01' = {
  name: environmentName
  location: location
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: logAnalytics.properties.customerId
        sharedKey: logAnalytics.listKeys().primarySharedKey
      }
    }
    vnetConfiguration: {
      infrastructureSubnetId: sourceVnet.properties.subnets[0].id
    }
  }
}

resource sourceApp 'Microsoft.App/containerApps@2023-05-01' = {
  name: appName
  location: location
  properties: {
    managedEnvironmentId: sourceEnvironment.id
    configuration: {
      ingress: {
        external: true
        targetPort: 80
      }
    }
    template: {
      containers: [
        {
          name: 'eshop-source'
          image: sourceImage
          resources: {
            cpu: json('0.5')
            memory: '1Gi'
          }
        }
      ]
      scale: {
        minReplicas: 1
        maxReplicas: 1
      }
    }
  }
}

output sourceVnetName string = sourceVnet.name
output sourceEnvironmentName string = sourceEnvironment.name
output sourceAppName string = sourceApp.name
output sourceAppUrl string = 'https://${sourceApp.properties.configuration.ingress.fqdn}'
