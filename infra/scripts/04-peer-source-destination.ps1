param(
    [Parameter(Mandatory = $true)]
    [string]$SourceResourceGroupName,

    [Parameter(Mandatory = $true)]
    [string]$SourceVnetName,

    [Parameter(Mandatory = $true)]
    [string]$DestinationResourceGroupName,

    [Parameter(Mandatory = $true)]
    [string]$DestinationVnetName
)

$ErrorActionPreference = 'Stop'

$sourceVnetId = az network vnet show --resource-group $SourceResourceGroupName --name $SourceVnetName --query id -o tsv
$destinationVnetId = az network vnet show --resource-group $DestinationResourceGroupName --name $DestinationVnetName --query id -o tsv

az network vnet peering create `
    --resource-group $SourceResourceGroupName `
    --vnet-name $SourceVnetName `
    --name source-to-destination `
    --remote-vnet $destinationVnetId `
    --allow-vnet-access | Out-Null

az network vnet peering create `
    --resource-group $DestinationResourceGroupName `
    --vnet-name $DestinationVnetName `
    --name destination-to-source `
    --remote-vnet $sourceVnetId `
    --allow-vnet-access | Out-Null

Write-Host 'Source and destination VNets are peered.'
