# 10 - Containerize And Stage Services

## Objective

Containerize eShopOnWeb and prepare it for deployment to AKS.

## Architecture Explanation

The source monolith remains running on the VM while you create a container image and deploy that image to AKS. This gives you side-by-side validation before any traffic shift or deeper service extraction.

## Azure Services Used

- Docker or compatible container build tooling.
- A registry selected by the attendee, usually ACR for Track B and regulated registry access for Track C.
- AKS.
- Kubernetes manifests or portal-created workloads authored by the attendee.

## Steps

1. Review the eShopOnWeb source under `src/monolith/eShopOnWeb`.
2. Create or adapt a Dockerfile for the web application.
3. Build the image locally or through your selected registry build feature.
4. Push the image to a registry that AKS can access.
5. Author Kubernetes deployment and service configuration yourself.
6. Deploy to AKS with the portal, Azure CLI, `kubectl`, or a combination.
7. Validate the pod status, service endpoint, and application response.

## Expected Outcome

The VM-hosted application has a containerized equivalent ready to run on AKS.
