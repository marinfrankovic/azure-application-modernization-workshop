# 10 - Containerize And Stage Services - Azure Portal

## Objective

Stage extracted service containers in the destination environment.

## Steps

1. Build service images locally or in CI.
2. Push images to the selected registry.
3. For Track A, update Container Apps image settings.
4. For Track B, deploy Kubernetes manifests to AKS and verify pods.
5. For Track C, confirm private registry access and approved image admission.
6. Test service health endpoints.

## Expected Outcome

Extracted services are deployed in the destination but traffic shift remains controlled.
