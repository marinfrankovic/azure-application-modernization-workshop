param(
    [Parameter(Mandatory = $true)]
    [string]$ResourceGroupName
)

$ErrorActionPreference = 'Stop'

Write-Host 'Resource summary:'
az resource list --resource-group $ResourceGroupName --query "[].{name:name,type:type,location:location}" -o table

Write-Host 'Virtual machines:'
az vm list --resource-group $ResourceGroupName -d --query "[].{name:name,powerState:powerState,privateIps:privateIps,publicIps:publicIps}" -o table 2>$null

Write-Host 'Virtual networks:'
az network vnet list --resource-group $ResourceGroupName --query "[].{name:name,addressPrefixes:addressSpace.addressPrefixes}" -o table 2>$null

Write-Host 'AKS clusters:'
az aks list --resource-group $ResourceGroupName --query "[].{name:name,kubernetesVersion:kubernetesVersion,powerState:powerState.code}" -o table 2>$null
