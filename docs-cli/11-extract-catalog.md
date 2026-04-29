# 11 - Extract Catalog

## Objective

Move catalog reads from the source monolith path to a destination service.

## Architecture Explanation

Catalog is a practical first extraction because it is visible, read-heavy, and easier to validate. The source remains available as fallback while destination catalog is tested.

## Azure Services Used

- Track A: Container Apps ingress.
- Track B: APIM route to AKS catalog service.
- Track C: private endpoint or internal ingress pattern.

## Steps

1. Compare eShopOnWeb catalog data and `src/services/catalog/app.py` response shape.
2. Deploy catalog service in destination.
3. Test catalog service directly.
4. Route catalog traffic through the selected gateway or ingress.
5. Keep source monolith route documented for rollback.

## Expected Outcome

Catalog requests can be served from the destination environment.
