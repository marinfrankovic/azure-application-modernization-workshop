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
if ($LASTEXITCODE -ne 0 -or -not $sourceVnetId) { throw "Source VNet not found: $SourceResourceGroupName/$SourceVnetName." }

$destinationVnetId = az network vnet show --resource-group $DestinationResourceGroupName --name $DestinationVnetName --query id -o tsv
if ($LASTEXITCODE -ne 0 -or -not $destinationVnetId) { throw "Destination VNet not found: $DestinationResourceGroupName/$DestinationVnetName." }

az network vnet peering create `
    --resource-group $SourceResourceGroupName `
    --vnet-name $SourceVnetName `
    --name source-to-destination `
    --remote-vnet $destinationVnetId `
    --allow-vnet-access | Out-Null
if ($LASTEXITCODE -ne 0) { throw 'Failed to create source-to-destination VNet peering.' }

az network vnet peering create `
    --resource-group $DestinationResourceGroupName `
    --vnet-name $DestinationVnetName `
    --name destination-to-source `
    --remote-vnet $sourceVnetId `
    --allow-vnet-access | Out-Null
if ($LASTEXITCODE -ne 0) { throw 'Failed to create destination-to-source VNet peering.' }

Write-Host 'Source and destination VNets are peered.'
