@description('Short lowercase prefix for the Track A destination foundation.')
param prefix string

@description('Azure region for the destination foundation.')
param location string = resourceGroup().location

var vnetName = '${prefix}-dest-simple-vnet'

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
        name: 'aks-system'
        properties: {
          addressPrefix: '10.20.1.0/24'
        }
      }
      {
        name: 'ingress'
        properties: {
          addressPrefix: '10.20.2.0/24'
        }
      }
    ]
  }
}

output destinationVnetName string = destinationVnet.name
output aksSubnetName string = 'aks-system'
output ingressSubnetName string = 'ingress'
