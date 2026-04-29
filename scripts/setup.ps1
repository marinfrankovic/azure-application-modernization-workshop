param(
    [Parameter(Mandatory = $true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory = $true)]
    [string]$Location,

    [Parameter(Mandatory = $true)]
    [string]$Prefix
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot

Write-Host "Creating resource group $ResourceGroupName in $Location"
az group create --name $ResourceGroupName --location $Location | Out-Null

Write-Host "Deploying AKS, ACR, Service Bus, Log Analytics, and Application Insights"
az deployment group create `
    --resource-group $ResourceGroupName `
    --template-file "$repoRoot/infra/bicep/main.bicep" `
    --parameters prefix=$Prefix location=$Location

Write-Host "Setup complete. Use deploy-monolith.ps1 or deploy-services.ps1 next."
