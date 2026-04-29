@description('Short lowercase prefix for regulated destination resources.')
param prefix string

@description('Azure region for regulated destination resources.')
param location string = resourceGroup().location

@description('Object ID that administers Key Vault secrets for the lab.')
param adminObjectId string

var normalizedPrefix = toLower(replace(prefix, '-', ''))
var workspaceName = '${prefix}-dest-reg-law'
var vnetName = '${prefix}-dest-reg-vnet'
var keyVaultName = take('${normalizedPrefix}kv${uniqueString(resourceGroup().id)}', 24)
var acrName = take('${normalizedPrefix}regacr${uniqueString(resourceGroup().id)}', 50)

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

resource vnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.40.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'workloads'
        properties: {
          addressPrefix: '10.40.1.0/24'
        }
      }
      {
        name: 'private-endpoints'
        properties: {
          addressPrefix: '10.40.2.0/24'
          privateEndpointNetworkPolicies: 'Disabled'
        }
      }
    ]
  }
}

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    tenantId: tenant().tenantId
    sku: {
      family: 'A'
      name: 'standard'
    }
    enableRbacAuthorization: true
    publicNetworkAccess: 'Disabled'
    softDeleteRetentionInDays: 7
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
    publicNetworkAccess: 'Disabled'
  }
}

resource adminSecretsOfficer 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(keyVault.id, adminObjectId, 'Key Vault Secrets Officer')
  scope: keyVault
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b86a8fe4-44ce-4948-aee5-eccb2c155cd7')
    principalId: adminObjectId
    principalType: 'User'
  }
}

output destinationVnetName string = vnet.name
output keyVaultName string = keyVault.name
output acrName string = acr.name
output logAnalyticsWorkspaceName string = logAnalytics.name
