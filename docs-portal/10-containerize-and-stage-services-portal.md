# 10 - Containerize And Stage Services - Azure Portal

## Objective

Containerize eShopOnWeb and deploy the image to AKS.

## Steps

1. Build the eShopOnWeb image locally, in Cloud Shell, or in a registry build workflow.
2. Push images to the selected registry.
3. Confirm AKS has permission and network access to pull the image.
4. Deploy Kubernetes resources to AKS and verify pods.
5. For Track C, confirm private registry access and approved image admission.
6. Test the application endpoint.

## Expected Outcome

The VM-hosted monolith has an AKS-hosted equivalent ready for validation.
