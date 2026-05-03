# 03 - Prepare Source Environment

## Objective

Create the source environment in your own Azure subscription. This is a required self-service step for every attendee or team.

## Architecture Explanation

The source environment represents the existing Azure-hosted monolith. Deploying it yourself keeps the workshop portable: every attendee has the same baseline without relying on shared infrastructure.

## Azure Services Used

- Resource group for source.
- Source VNet.
- Container Apps environment for the source app.
- Log Analytics workspace.

## Steps

1. Choose a source resource group, region, and prefix.
2. For the normal workshop path, deploy source and destination together:

```powershell
./infra/scripts/00-deploy-workshop.ps1 -Track A -Location westeurope -Prefix appmod42
```

3. To deploy only the source environment for manual labs, run:

```powershell
./infra/scripts/00-prepare-source.ps1 -SourceResourceGroupName rg-appmod-source -Location westeurope -Prefix appmodsrc
```

4. Record these values from deployment outputs or the generated report:
   - Source resource group name.
   - Source VNet name.
   - Source application URL.
   - Region.
5. Validate the source URL.
6. Keep the source resources available during decomposition so they remain the baseline and rollback anchor.

## Expected Outcome

The source environment is ready in your Azure subscription and can be used as the baseline for destination decomposition.
