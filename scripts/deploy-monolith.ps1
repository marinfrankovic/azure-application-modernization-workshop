param(
    [Parameter(Mandatory = $true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory = $true)]
    [string]$Prefix
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$monolithRoot = Join-Path $repoRoot 'src/monolith/eShopOnWeb'
$normalizedPrefix = $Prefix -replace '-', ''

if (-not (Test-Path $monolithRoot)) {
    throw 'eShopOnWeb submodule is missing. Run: git submodule update --init --recursive'
}

$aksName = az aks list --resource-group $ResourceGroupName --query "[?starts_with(name, '$Prefix')].name | [0]" -o tsv
$acrLoginServer = az acr list --resource-group $ResourceGroupName --query "[?starts_with(name, '$normalizedPrefix')].loginServer | [0]" -o tsv
$acrName = ($acrLoginServer -split '\.')[0]

if (-not $aksName -or -not $acrLoginServer) {
    throw 'Could not resolve AKS or ACR. Run scripts/setup.ps1 first.'
}

az aks get-credentials --resource-group $ResourceGroupName --name $aksName --overwrite-existing
az acr login --name $acrName

$image = "$acrLoginServer/eshopweb:latest"
Write-Host "Building eShopOnWeb monolith image $image"
docker build --pull -t $image -f "$monolithRoot/src/Web/Dockerfile" $monolithRoot
docker push $image

$tempManifest = New-TemporaryFile
(Get-Content "$repoRoot/infra/aks/monolith.yaml") `
    -replace 'REPLACE_ACR_LOGIN_SERVER/monolith:latest', $image `
    | Set-Content $tempManifest

kubectl apply -f $tempManifest
kubectl rollout status deployment/monolith
kubectl get service monolith
