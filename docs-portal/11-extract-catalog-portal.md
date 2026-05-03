# 11 - Extract Catalog - Azure Portal

## Objective

Plan catalog extraction after the AKS migration baseline is running.

## Steps

1. Inspect catalog-related pages, controllers, and data access in eShopOnWeb.
2. Confirm the AKS-hosted monolith serves catalog pages successfully.
3. Define the catalog API boundary you would extract first.
4. In Track B, plan an APIM `/catalog` route to a future AKS backend.
5. In Track C, validate how private ingress and DNS would expose catalog safely.
6. Keep source catalog route documented for rollback.

## Expected Outcome

You have a catalog extraction plan based on the migrated AKS baseline.
