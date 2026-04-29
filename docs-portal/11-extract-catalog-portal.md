# 11 - Extract Catalog - Azure Portal

## Objective

Route catalog reads to the destination catalog service.

## Steps

1. Open destination catalog service resource.
2. Confirm health endpoint works.
3. In Track A, use the Container Apps URL for catalog testing.
4. In Track B, configure APIM `/catalog` route to the AKS backend.
5. In Track C, validate private ingress and DNS.
6. Keep source catalog route documented for rollback.

## Expected Outcome

Catalog can be served from the destination environment.
