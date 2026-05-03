param(
    [ValidateSet('A', 'B', 'C')]
    [string]$Track = 'A',

    [Parameter(Mandatory = $true)]
    [string]$Prefix,

    [Parameter(Mandatory = $true)]
    [string]$Location,

    [string]$SourceResourceGroupName,

    [string]$DestinationResourceGroupName,

    [switch]$SkipPeering,

    [string]$ReportPath
)

$ErrorActionPreference = 'Stop'
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '../..')

if (-not $SourceResourceGroupName) {
    $SourceResourceGroupName = "rg-$Prefix-source"
}

$trackSuffix = $Track.ToLowerInvariant()
if (-not $DestinationResourceGroupName) {
    $DestinationResourceGroupName = "rg-$Prefix-dest-$trackSuffix"
}

if (-not $ReportPath) {
    $outputFolder = Join-Path $repoRoot 'output'
    New-Item -ItemType Directory -Path $outputFolder -Force | Out-Null
    $timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $ReportPath = Join-Path $outputFolder "deployment-report-$timestamp.md"
}

$sourcePrefix = "${Prefix}src"
$destinationPrefix = "${Prefix}${trackSuffix}"
$sourceVnetName = "$sourcePrefix-source-vnet"
$destinationVnetName = switch ($Track) {
    'A' { "$destinationPrefix-dest-simple-vnet" }
    'B' { "$destinationPrefix-dest-ent-vnet" }
    'C' { "$destinationPrefix-dest-reg-vnet" }
}
$destinationDeploymentName = switch ($Track) {
    'A' { 'destination-simple-aks-vnet' }
    'B' { 'destination-enterprise-aks' }
    'C' { 'destination-regulated-private' }
}

$steps = New-Object System.Collections.Generic.List[object]
$errors = New-Object System.Collections.Generic.List[string]
$overallTimer = [System.Diagnostics.Stopwatch]::StartNew()
$deploymentFailed = $false

function Invoke-WorkshopStep {
    param(
        [Parameter(Mandatory = $true)] [string]$Name,
        [Parameter(Mandatory = $true)] [scriptblock]$Command
    )

    Write-Host "==> $Name"
    $timer = [System.Diagnostics.Stopwatch]::StartNew()
    try {
        & $Command
        $timer.Stop()
        $script:steps.Add([pscustomobject]@{
            Name = $Name
            Status = 'Succeeded'
            Seconds = [math]::Round($timer.Elapsed.TotalSeconds, 1)
        }) | Out-Null
    }
    catch {
        $timer.Stop()
        $message = $_.Exception.Message
        $script:steps.Add([pscustomobject]@{
            Name = $Name
            Status = 'Failed'
            Seconds = [math]::Round($timer.Elapsed.TotalSeconds, 1)
        }) | Out-Null
        $script:errors.Add("${Name}: $message") | Out-Null
        throw
    }
}

function Get-ResourceSummary {
    param([string]$ResourceGroupName)

    $exists = az group exists --name $ResourceGroupName -o tsv 2>$null
    if ($exists -ne 'true') {
        return @()
    }

    az resource list --resource-group $ResourceGroupName --query "[].{name:name,type:type,location:location}" -o json | ConvertFrom-Json
}

function Get-DeploymentOutputs {
    param(
        [string]$ResourceGroupName,
        [string]$DeploymentName
    )

    $json = az deployment group show --resource-group $ResourceGroupName --name $DeploymentName --query properties.outputs -o json 2>$null
    if (-not $json) {
        return $null
    }

    return $json | ConvertFrom-Json
}

$account = az account show --query "{name:name,id:id,tenantId:tenantId,user:user.name}" -o json | ConvertFrom-Json
Write-Host "Deploying workshop foundation to subscription '$($account.name)' ($($account.id))."
Write-Host "Track: $Track"
Write-Host "Source resource group: $SourceResourceGroupName"
Write-Host "Destination resource group: $DestinationResourceGroupName"

try {
    Invoke-WorkshopStep -Name 'Deploy source VM environment' -Command {
        & (Join-Path $PSScriptRoot '00-prepare-source.ps1') `
            -SourceResourceGroupName $SourceResourceGroupName `
            -Location $Location `
            -Prefix $sourcePrefix
    }

    Invoke-WorkshopStep -Name "Deploy Track $Track destination VNet" -Command {
        switch ($Track) {
            'A' {
                & (Join-Path $PSScriptRoot '01-deploy-track-a-simple.ps1') `
                    -DestinationResourceGroupName $DestinationResourceGroupName `
                    -Location $Location `
                    -Prefix $destinationPrefix
            }
            'B' {
                & (Join-Path $PSScriptRoot '02-deploy-track-b-enterprise.ps1') `
                    -DestinationResourceGroupName $DestinationResourceGroupName `
                    -Location $Location `
                    -Prefix $destinationPrefix
            }
            'C' {
                & (Join-Path $PSScriptRoot '03-deploy-track-c-regulated.ps1') `
                    -DestinationResourceGroupName $DestinationResourceGroupName `
                    -Location $Location `
                    -Prefix $destinationPrefix
            }
        }
    }

    if (-not $SkipPeering) {
        Invoke-WorkshopStep -Name 'Peer source and destination VNets' -Command {
            & (Join-Path $PSScriptRoot '04-peer-source-destination.ps1') `
                -SourceResourceGroupName $SourceResourceGroupName `
                -SourceVnetName $sourceVnetName `
                -DestinationResourceGroupName $DestinationResourceGroupName `
                -DestinationVnetName $destinationVnetName
        }
    }

    Invoke-WorkshopStep -Name 'Validate source resources' -Command {
        & (Join-Path $PSScriptRoot 'validate.ps1') -ResourceGroupName $SourceResourceGroupName
    }

    Invoke-WorkshopStep -Name 'Validate destination resources' -Command {
        & (Join-Path $PSScriptRoot 'validate.ps1') -ResourceGroupName $DestinationResourceGroupName
    }
}
catch {
    $deploymentFailed = $true
    Write-Warning 'Deployment did not complete successfully. A report will still be written with captured errors.'
}

$overallTimer.Stop()

$sourceResources = Get-ResourceSummary -ResourceGroupName $SourceResourceGroupName
$destinationResources = Get-ResourceSummary -ResourceGroupName $DestinationResourceGroupName
$sourceOutputs = Get-DeploymentOutputs -ResourceGroupName $SourceResourceGroupName -DeploymentName 'source-prepared'
$destinationOutputs = Get-DeploymentOutputs -ResourceGroupName $DestinationResourceGroupName -DeploymentName $destinationDeploymentName
$sourceUrl = if ($sourceOutputs -and $sourceOutputs.sourceAppUrl) { $sourceOutputs.sourceAppUrl.value } else { '' }
$sshCommand = if ($sourceOutputs -and $sourceOutputs.sshCommand) { $sourceOutputs.sshCommand.value } else { '' }
$sourceVmName = if ($sourceOutputs -and $sourceOutputs.sourceVmName) { $sourceOutputs.sourceVmName.value } else { '' }
$destinationVnetOutput = if ($destinationOutputs -and $destinationOutputs.destinationVnetName) { $destinationOutputs.destinationVnetName.value } else { $destinationVnetName }

$report = New-Object System.Collections.Generic.List[string]
$report.Add('# Azure Application Modernization Workshop Foundation Report') | Out-Null
$report.Add('') | Out-Null
$report.Add("Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz')") | Out-Null
$report.Add("Subscription: $($account.name) ($($account.id))") | Out-Null
$report.Add("Tenant: $($account.tenantId)") | Out-Null
$report.Add("Signed-in user: $($account.user)") | Out-Null
$report.Add("Location: $Location") | Out-Null
$report.Add("Track: $Track") | Out-Null
$report.Add("Status: $(if ($deploymentFailed) { 'Failed' } else { 'Succeeded' })") | Out-Null
$report.Add("Total foundation deployment time: $([math]::Round($overallTimer.Elapsed.TotalMinutes, 1)) minutes") | Out-Null
$report.Add('') | Out-Null
$report.Add('## Resource Groups') | Out-Null
$report.Add('') | Out-Null
$report.Add(('- Source: `{0}`' -f $SourceResourceGroupName)) | Out-Null
$report.Add(('- Destination: `{0}`' -f $DestinationResourceGroupName)) | Out-Null
$report.Add('') | Out-Null
$report.Add('## Provisioned Foundation') | Out-Null
$report.Add('') | Out-Null
$report.Add(('- Source VM: `{0}`' -f $sourceVmName)) | Out-Null
$report.Add("- Source eShopOnWeb URL: $sourceUrl") | Out-Null
$report.Add(('- Destination VNet: `{0}`' -f $destinationVnetOutput)) | Out-Null
$report.Add('') | Out-Null
$report.Add('## Access Notes') | Out-Null
$report.Add('') | Out-Null
$report.Add('- Initial provisioning creates only the source VM environment and destination VNet foundation.') | Out-Null
$report.Add('- Attendees create AKS and all track-specific Azure services during the workshop by using the Azure portal, Azure CLI, or both.') | Out-Null
$report.Add(('- SSH command: `{0}`' -f $sshCommand)) | Out-Null
$report.Add('- A local SSH private key may be generated under ignored `output/ssh/`; do not commit it.') | Out-Null
$report.Add('') | Out-Null
$report.Add('## Timings') | Out-Null
$report.Add('') | Out-Null
$report.Add('| Step | Status | Seconds |') | Out-Null
$report.Add('| --- | --- | ---: |') | Out-Null
foreach ($step in $steps) {
    $report.Add("| $($step.Name) | $($step.Status) | $($step.Seconds) |") | Out-Null
}
$report.Add('') | Out-Null
$report.Add('## Source Artifacts') | Out-Null
$report.Add('') | Out-Null
foreach ($resource in $sourceResources) {
    $report.Add(('- `{0}` ({1}, {2})' -f $resource.name, $resource.type, $resource.location)) | Out-Null
}
$report.Add('') | Out-Null
$report.Add('## Destination Artifacts') | Out-Null
$report.Add('') | Out-Null
foreach ($resource in $destinationResources) {
    $report.Add(('- `{0}` ({1}, {2})' -f $resource.name, $resource.type, $resource.location)) | Out-Null
}
$report.Add('') | Out-Null
$report.Add('## Errors') | Out-Null
$report.Add('') | Out-Null
if ($errors.Count -eq 0) {
    $report.Add('- None captured.') | Out-Null
}
else {
    foreach ($errorItem in $errors) {
        $report.Add("- $errorItem") | Out-Null
    }
}

Set-Content -Path $ReportPath -Value $report -Encoding utf8
Write-Host "Deployment report written to $ReportPath"

if ($deploymentFailed) {
    exit 1
}
