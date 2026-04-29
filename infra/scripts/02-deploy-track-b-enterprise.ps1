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
az deployment group create `
    --resource-group $DestinationResourceGroupName `
    --template-file "$repoRoot/infra/bicep/destination-enterprise-aks.bicep" `
    --parameters prefix=$Prefix location=$Location

Write-Host 'Track B enterprise destination is ready. Use deploy-services.ps1 to publish service images to AKS.'
