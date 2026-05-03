# 04 - Track A: Simple AKS Migration

## Objective

Migrate the VM-hosted eShopOnWeb monolith to a basic AKS deployment.

## Architecture Explanation

Track A keeps the platform light while still using AKS. The workshop provisions the source VM and a destination VNet only. You create a small AKS cluster, containerize eShopOnWeb, deploy it to AKS, and validate that users can reach the workload.

Choose this track if you want a focused modernization path with the fewest platform services.

## Azure Services Used

- Destination VNet.
- AKS.
- Container image registry of your choice, such as ACR or a temporary lab registry.
- Kubernetes deployment and service resources that you define.

## Steps

1. Deploy the workshop foundation:

```powershell
./infra/scripts/01-deploy-track-a-simple.ps1 -DestinationResourceGroupName rg-appmod-dest-a -Location westeurope -Prefix appmoda
```

2. Confirm the destination resource group contains only the destination VNet and subnets.
3. Create AKS in the destination VNet by using the portal or Azure CLI.
4. Containerize eShopOnWeb from `src/monolith/eShopOnWeb`.
5. Build and push the image to your selected registry.
6. Create Kubernetes manifests for the eShopOnWeb deployment and service.
7. Deploy the workload to AKS.
8. Validate resources:

```powershell
./infra/scripts/validate.ps1 -ResourceGroupName rg-appmod-dest-a
```

9. Browse the AKS workload endpoint and compare it with the source VM URL.

## Validation Criteria

- The source VM URL still serves the original eShopOnWeb application.
- AKS exists in the destination VNet.
- The eShopOnWeb image is built from the monolith source and stored in a registry.
- Kubernetes pods reach `Running` state.
- A Kubernetes service or ingress exposes the application.
- The AKS-hosted application responds successfully in a browser or with `curl`.
- You can explain the rollback path to the source VM.

## Expected Outcome

The monolith is running on AKS with a minimal, understandable target architecture.
