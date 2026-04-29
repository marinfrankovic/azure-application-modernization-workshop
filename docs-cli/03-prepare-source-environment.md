# 03 - Prepare Source Environment

## Objective

Create the ready source environment before attendees begin. This lab is normally run by the facilitator.

## Architecture Explanation

The source environment represents the existing Azure-hosted monolith. It must be ready before the workshop so attendees focus on destination setup and decomposition rather than initial migration.

## Azure Services Used

- Resource group for source.
- Source VNet.
- Container Apps environment for the prepared source app.
- Log Analytics workspace.

## Steps

1. Choose a source resource group, region, and prefix.
2. Run:

```powershell
./infra/scripts/00-prepare-source.ps1 -SourceResourceGroupName rg-appmod-source -Location westeurope -Prefix appmodsrc
```

3. Capture outputs for attendees:
   - Source resource group name.
   - Source VNet name.
   - Source application URL.
   - Region.
4. Validate the source URL.
5. Do not ask attendees to change source resources unless the facilitator explicitly chooses that mode.

## Expected Outcome

The source environment is ready and attendees can start with destination setup.
