param(
    [Parameter(Mandatory = $true)]
    [string[]]$ResourceGroupNames
)

$ErrorActionPreference = 'Stop'

foreach ($resourceGroupName in $ResourceGroupNames) {
    Write-Host "Deleting $resourceGroupName"
    az group delete --name $resourceGroupName --yes --no-wait
}

Write-Host 'Cleanup submitted. Confirm deletion in the Azure portal or with az group show.'
