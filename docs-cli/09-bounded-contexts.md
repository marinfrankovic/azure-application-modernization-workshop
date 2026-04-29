# 09 - Bounded Contexts From eShopOnWeb

## Objective

Use eShopOnWeb source code to identify monolith services and extraction candidates.

## Architecture Explanation

The workshop does not invent a toy monolith. It uses eShopOnWeb as the source and maps real projects such as Web, PublicApi, ApplicationCore, and Infrastructure into capabilities including catalog, basket, ordering, identity, and shared data access.

## Azure Services Used

No new Azure service is required. This is an analysis lab.

## Steps

1. Open `src/monolith/eShopOnWeb/eShopOnWeb.sln`.
2. Review `src/Web`, `src/PublicApi`, `src/ApplicationCore`, and `src/Infrastructure`.
3. Build a capability map: catalog, basket, ordering, identity, data access.
4. Choose extraction order:
   - Catalog first for read-heavy traffic.
   - Notifications second for asynchronous decoupling.
   - Orders after integration paths are clear.
5. Record coupling and rollback decisions.

## Expected Outcome

You have a decomposition plan grounded in the source monolith.
