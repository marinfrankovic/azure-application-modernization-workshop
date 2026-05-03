param(
    [Parameter(Mandatory = $true)]
    [string]$DestinationResourceGroupName,

    [Parameter(Mandatory = $true)]
    [string]$Location,

    [Parameter(Mandatory = $true)]
    [string]$Prefix,

    [Parameter(Mandatory = $true)]
    [string]$AdminObjectId
)

$ErrorActionPreference = 'Stop'
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '../..')

az group create --name $DestinationResourceGroupName --location $Location | Out-Null
if ($LASTEXITCODE -ne 0) { throw "Failed to create or update resource group $DestinationResourceGroupName." }

az deployment group create `
    --resource-group $DestinationResourceGroupName `
    --template-file "$repoRoot/infra/bicep/destination-regulated-private.bicep" `
    --parameters prefix=$Prefix location=$Location adminObjectId=$AdminObjectId
if ($LASTEXITCODE -ne 0) { throw "Track C destination deployment failed for $DestinationResourceGroupName." }

Write-Host 'Track C regulated landing zone is ready. Continue with private endpoint, Defender, and Key Vault hardening labs.'
