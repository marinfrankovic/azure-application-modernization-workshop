# 11 - Extract Catalog

## Objective

Plan the first functional extraction after the monolith is running on AKS.

## Architecture Explanation

Catalog is a practical first extraction because it is visible, read-heavy, and easier to validate. In this workshop, first prove the full monolith can run on AKS, then identify how catalog could become an independently deployed service in a later iteration.

## Azure Services Used

- AKS workload or namespace boundaries.
- Optional APIM route in Track B.
- Private ingress or approved internal access in Track C.

## Steps

1. Identify catalog-related controllers, pages, data access, and dependencies in eShopOnWeb.
2. Define what catalog API contract would be separated first.
3. Decide whether the selected track would expose catalog directly through AKS ingress, through APIM, or through a private route.
4. Document the validation data you would compare between the source VM and AKS-hosted application.
5. Keep the source monolith route documented for rollback.

## Expected Outcome

You have a concrete catalog extraction plan grounded in the AKS migration target.
