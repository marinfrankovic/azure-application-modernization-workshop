param(
    [Parameter(Mandatory = $true)]
    [string]$DestinationResourceGroupName,

    [Parameter(Mandatory = $true)]
    [string]$Location,

    [Parameter(Mandatory = $true)]
    [string]$Prefix
)

$ErrorActionPreference = 'Stop'
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '../..')

az group create --name $DestinationResourceGroupName --location $Location | Out-Null
if ($LASTEXITCODE -ne 0) { throw "Failed to create or update resource group $DestinationResourceGroupName." }

az deployment group create `
    --resource-group $DestinationResourceGroupName `
    --template-file "$repoRoot/infra/bicep/destination-regulated-private.bicep" `
    --parameters prefix=$Prefix location=$Location
if ($LASTEXITCODE -ne 0) { throw "Track C destination deployment failed for $DestinationResourceGroupName." }

Write-Host 'Track C regulated destination VNet is ready. Attendees create private AKS, Key Vault, Defender configuration, and private access during the lab.'
