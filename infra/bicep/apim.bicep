@description('Short prefix used for APIM resource names.')
param prefix string

@description('Azure region for API Management.')
param location string = resourceGroup().location

@description('Publisher email shown in APIM.')
param publisherEmail string

@description('Publisher name shown in APIM.')
param publisherName string = 'Workshop Team'

var apimName = take('${prefix}-apim-${uniqueString(resourceGroup().id)}', 50)

resource apim 'Microsoft.ApiManagement/service@2023-09-01-preview' = {
  name: apimName
  location: location
  sku: {
    name: 'Developer'
    capacity: 1
  }
  properties: {
    publisherEmail: publisherEmail
    publisherName: publisherName
  }
}

resource productsApi 'Microsoft.ApiManagement/service/apis@2023-09-01-preview' = {
  parent: apim
  name: 'workshop-api'
  properties: {
    displayName: 'Application Modernization Workshop API'
    path: 'workshop'
    protocols: [
      'https'
    ]
    serviceUrl: 'https://example.invalid'
  }
}

output apimName string = apim.name
output gatewayUrl string = apim.properties.gatewayUrl
