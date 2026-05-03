# 04 - Track A: Simple AKS - Azure Portal

## Objective

Create a basic AKS target through the portal and migrate eShopOnWeb from the VM.

## Steps

1. Open the Track A destination resource group and VNet created by the foundation script.
2. Create an AKS cluster in the destination VNet.
3. Create or select a container registry and make sure AKS can pull images from it.
4. Build and push the eShopOnWeb container image.
5. Use the Kubernetes resources experience or Cloud Shell to create a deployment and service.
6. Confirm pods are running and expose the application through a service or ingress.
7. Test the AKS-hosted application URL and compare it with the source VM URL.

## Validation Criteria

- AKS exists in the destination VNet.
- The eShopOnWeb image is available in a registry.
- Pods are running.
- The application is reachable through the selected Kubernetes exposure path.

## Expected Outcome

Track A proves the monolith can move from VM hosting to AKS with a simple target architecture.
