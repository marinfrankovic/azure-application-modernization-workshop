@description('Short lowercase prefix for enterprise destination resources.')
param prefix string

@description('Azure region for the enterprise destination environment.')
param location string = resourceGroup().location

@minValue(1)
@maxValue(5)
param nodeCount int = 2

param nodeVmSize string = 'Standard_DS2_v2'

var normalizedPrefix = toLower(replace(prefix, '-', ''))
var acrName = take('${normalizedPrefix}acr${uniqueString(resourceGroup().id)}', 50)
var aksName = '${prefix}-dest-aks'
var workspaceName = '${prefix}-dest-ent-law'
var appInsightsName = '${prefix}-dest-ent-appi'
var serviceBusName = take('${prefix}-dest-sb-${uniqueString(resourceGroup().id)}', 50)
var vnetName = '${prefix}-dest-ent-vnet'

resource destinationVnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.30.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'aks'
        properties: {
          addressPrefix: '10.30.1.0/24'
        }
      }
      {
        name: 'apim'
        properties: {
          addressPrefix: '10.30.2.0/24'
        }
      }
    ]
  }
}

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

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalytics.id
  }
}

resource acr 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: acrName
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: false
  }
}

resource serviceBus 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' = {
  name: serviceBusName
  location: location
  sku: {
    name: 'Standard'
    tier: 'Standard'
  }
}

resource notificationsQueue 'Microsoft.ServiceBus/namespaces/queues@2022-10-01-preview' = {
  parent: serviceBus
  name: 'notifications'
  properties: {
    maxDeliveryCount: 10
    deadLetteringOnMessageExpiration: true
  }
}

resource aks 'Microsoft.ContainerService/managedClusters@2024-05-01' = {
  name: aksName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: '${prefix}-dest-aks'
    agentPoolProfiles: [
      {
        name: 'systempool'
        count: nodeCount
        vmSize: nodeVmSize
        osType: 'Linux'
        mode: 'System'
        vnetSubnetID: destinationVnet.properties.subnets[0].id
      }
    ]
    networkProfile: {
      networkPlugin: 'azure'
      loadBalancerSku: 'standard'
      outboundType: 'loadBalancer'
    }
    addonProfiles: {
      omsagent: {
        enabled: true
        config: {
          logAnalyticsWorkspaceResourceID: logAnalytics.id
        }
      }
    }
  }
}

resource acrPull 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(aks.id, acr.id, 'AcrPull')
  scope: acr
  properties: {
    principalId: aks.properties.identityProfile.kubeletidentity.objectId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')
    principalType: 'ServicePrincipal'
  }
}

output destinationVnetName string = destinationVnet.name
output aksName string = aks.name
output acrLoginServer string = acr.properties.loginServer
output serviceBusNamespace string = serviceBus.name
output notificationsQueueName string = notificationsQueue.name
output appInsightsConnectionString string = appInsights.properties.ConnectionString
