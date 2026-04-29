param(
    [Parameter(Mandatory = $true)]
    [string]$ResourceGroupName
)

$ErrorActionPreference = 'Stop'

Write-Host 'Resource summary:'
az resource list --resource-group $ResourceGroupName --query "[].{name:name,type:type,location:location}" -o table

Write-Host 'Container Apps:'
az containerapp list --resource-group $ResourceGroupName --query "[].{name:name,environment:properties.managedEnvironmentId,state:properties.runningStatus}" -o table 2>$null

Write-Host 'AKS clusters:'
az aks list --resource-group $ResourceGroupName --query "[].{name:name,kubernetesVersion:kubernetesVersion,powerState:powerState.code}" -o table 2>$null
