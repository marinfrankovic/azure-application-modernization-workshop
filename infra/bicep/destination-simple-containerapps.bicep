@description('Short lowercase prefix for destination resources.')
param prefix string

@description('Azure region for the destination environment.')
param location string = resourceGroup().location

@description('Container image for the extracted catalog service.')
param catalogImage string = 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'

@description('Container image for the extracted orders service.')
param ordersImage string = 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'

@description('Container image for the extracted inventory service.')
param inventoryImage string = 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'

@description('Container image for the extracted notifications service.')
param notificationsImage string = 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'

var workspaceName = '${prefix}-dest-simple-law'
var vnetName = '${prefix}-dest-simple-vnet'
var envName = '${prefix}-dest-simple-cae'

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

resource destinationVnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.20.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'containerapps'
        properties: {
          addressPrefix: '10.20.1.0/23'
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

resource environment 'Microsoft.App/managedEnvironments@2023-05-01' = {
  name: envName
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
      infrastructureSubnetId: destinationVnet.properties.subnets[0].id
    }
  }
}

var apps = [
  {
    name: 'catalog'
    image: catalogImage
    external: true
  }
  {
    name: 'orders'
    image: ordersImage
    external: true
  }
  {
    name: 'inventory'
    image: inventoryImage
    external: false
  }
  {
    name: 'notifications'
    image: notificationsImage
    external: false
  }
]

resource containerApps 'Microsoft.App/containerApps@2023-05-01' = [for app in apps: {
  name: '${prefix}-${app.name}'
  location: location
  properties: {
    managedEnvironmentId: environment.id
    configuration: {
      ingress: {
        external: app.external
        targetPort: 8000
      }
    }
    template: {
      containers: [
        {
          name: app.name
          image: app.image
          resources: {
            cpu: json('0.25')
            memory: '0.5Gi'
          }
        }
      ]
      scale: {
        minReplicas: 0
        maxReplicas: 2
      }
    }
  }
}]

output destinationVnetName string = destinationVnet.name
output containerAppsEnvironmentName string = environment.name
output catalogUrl string = 'https://${containerApps[0].properties.configuration.ingress.fqdn}'
output ordersUrl string = 'https://${containerApps[1].properties.configuration.ingress.fqdn}'
