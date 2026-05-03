@description('Short lowercase prefix for the Track C destination foundation.')
param prefix string

@description('Azure region for the regulated destination foundation.')
param location string = resourceGroup().location

var vnetName = '${prefix}-dest-reg-vnet'

resource destinationVnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
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
        name: 'aks-private'
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
      {
        name: 'ingress-private'
        properties: {
          addressPrefix: '10.40.3.0/24'
        }
      }
    ]
  }
}

output destinationVnetName string = destinationVnet.name
output aksSubnetName string = 'aks-private'
output privateEndpointSubnetName string = 'private-endpoints'
output privateIngressSubnetName string = 'ingress-private'
