# 04 - Track A: Simple Container Apps Destination

## Objective

Deploy a simple destination environment for decomposed services using Azure Container Apps.

## Architecture Explanation

Track A keeps the platform light. It is designed for teams that want to learn decomposition without managing Kubernetes. The destination VNet is separate from source, and extracted services run in Container Apps.

## Azure Services Used

- Azure Container Apps.
- Container Apps managed environment.
- Destination VNet.
- Log Analytics.

## Steps

1. Deploy the destination:

```powershell
./infra/scripts/01-deploy-track-a-simple.ps1 -DestinationResourceGroupName rg-appmod-dest-a -Location westeurope -Prefix appmoda
```

2. Capture destination VNet and Container Apps environment names.
3. Validate resources:

```powershell
./infra/scripts/validate.ps1 -ResourceGroupName rg-appmod-dest-a
```

4. Deploy extracted service container images when ready.
5. Use Container Apps ingress URLs for catalog and orders testing.

## Expected Outcome

A low-friction destination platform exists for extracted services.
