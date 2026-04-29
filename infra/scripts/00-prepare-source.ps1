param(
    [Parameter(Mandatory = $true)]
    [string]$SourceResourceGroupName,

    [Parameter(Mandatory = $true)]
    [string]$Location,

    [Parameter(Mandatory = $true)]
    [string]$Prefix
)

$ErrorActionPreference = 'Stop'
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '../..')

Write-Host 'Preparing source environment. This script is intended for facilitator use before attendees start.'
az group create --name $SourceResourceGroupName --location $Location | Out-Null
az deployment group create `
    --resource-group $SourceResourceGroupName `
    --template-file "$repoRoot/infra/bicep/source-prepared.bicep" `
    --parameters prefix=$Prefix location=$Location

Write-Host 'Source environment is ready. Share source app URL and source VNet name with attendees.'
