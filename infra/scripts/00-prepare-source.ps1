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

Write-Host 'Preparing source environment for the current workshop user.'
az group create --name $SourceResourceGroupName --location $Location | Out-Null
if ($LASTEXITCODE -ne 0) { throw "Failed to create or update resource group $SourceResourceGroupName." }

az deployment group create `
    --resource-group $SourceResourceGroupName `
    --template-file "$repoRoot/infra/bicep/source-prepared.bicep" `
    --parameters prefix=$Prefix location=$Location
if ($LASTEXITCODE -ne 0) { throw "Source environment deployment failed for $SourceResourceGroupName." }

Write-Host 'Source environment is ready. Use the deployment outputs or generated report for the source app URL and source VNet name.'
