param(
    [Parameter(Mandatory = $true)]
    [string]$SourceResourceGroupName,

    [Parameter(Mandatory = $true)]
    [string]$Location,

    [Parameter(Mandatory = $true)]
    [string]$Prefix,

    [string]$AdminUsername = 'azureuser',

    [string]$SshPublicKey
)

$ErrorActionPreference = 'Stop'
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '../..')

if (-not $SshPublicKey) {
    $sshFolder = Join-Path $repoRoot 'output/ssh'
    New-Item -ItemType Directory -Path $sshFolder -Force | Out-Null
    $keyPath = Join-Path $sshFolder "$Prefix-source-vm"
    if (-not (Test-Path $keyPath)) {
        ssh-keygen -t rsa -b 4096 -f $keyPath -N '' -C "$Prefix-source-vm" | Out-Null
        if ($LASTEXITCODE -ne 0) { throw 'Failed to generate SSH key for the source VM.' }
    }
    $SshPublicKey = Get-Content "$keyPath.pub" -Raw
    Write-Host "Generated or reused source VM SSH key: $keyPath"
}

Write-Host 'Preparing source VM environment for the current workshop user.'
az group create --name $SourceResourceGroupName --location $Location | Out-Null
if ($LASTEXITCODE -ne 0) { throw "Failed to create or update resource group $SourceResourceGroupName." }

az deployment group create `
    --resource-group $SourceResourceGroupName `
    --template-file "$repoRoot/infra/bicep/source-prepared.bicep" `
    --parameters prefix=$Prefix location=$Location adminUsername=$AdminUsername sshPublicKey="$SshPublicKey"
if ($LASTEXITCODE -ne 0) { throw "Source environment deployment failed for $SourceResourceGroupName." }

Write-Host 'Source VM environment is ready. Use the deployment outputs or generated report for the source app URL, VM name, and source VNet name.'
