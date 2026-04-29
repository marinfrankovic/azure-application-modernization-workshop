param(
    [Parameter(Mandatory = $true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory = $true)]
    [string]$Prefix
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$normalizedPrefix = $Prefix -replace '-', ''
$aksName = az aks list --resource-group $ResourceGroupName --query "[?starts_with(name, '$Prefix')].name | [0]" -o tsv
$acrLoginServer = az acr list --resource-group $ResourceGroupName --query "[?starts_with(name, '$normalizedPrefix')].loginServer | [0]" -o tsv
$acrName = ($acrLoginServer -split '\.')[0]

if (-not $aksName -or -not $acrLoginServer) {
    throw 'Could not resolve AKS or ACR. Run scripts/setup.ps1 first.'
}

az aks get-credentials --resource-group $ResourceGroupName --name $aksName --overwrite-existing
az acr login --name $acrName

$services = @('catalog-service', 'inventory-service', 'orders-service', 'notifications-service')
$paths = @{
    'catalog-service' = 'src/services/catalog'
    'inventory-service' = 'src/services/inventory'
    'orders-service' = 'src/services/orders'
    'notifications-service' = 'src/services/notifications'
}

foreach ($service in $services) {
    $context = Join-Path $repoRoot $paths[$service]
    $image = "$acrLoginServer/${service}:latest"
    Write-Host "Building $image"
    docker build -t $image $context
    docker push $image
}

$tempManifest = New-TemporaryFile
(Get-Content "$repoRoot/infra/aks/services.yaml") `
    -replace 'REPLACE_ACR_LOGIN_SERVER', $acrLoginServer `
    | Set-Content $tempManifest

kubectl apply -f $tempManifest
kubectl rollout status deployment/catalog-service
kubectl rollout status deployment/inventory-service
kubectl rollout status deployment/orders-service
kubectl rollout status deployment/notifications-service
kubectl get services
