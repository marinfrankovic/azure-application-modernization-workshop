# 13 - Data Decomposition

## Objective

Plan data ownership changes after service extraction.

## Architecture Explanation

Moving code without moving ownership creates distributed components that still depend on monolith data. This lab separates immediate lab behavior from production data ownership.

## Azure Services Used

- Optional Azure SQL or PostgreSQL for future service-owned stores.
- Service Bus for integration events.
- Key Vault for connection secret references.

## Steps

1. Identify eShopOnWeb data areas used by catalog, basket, ordering, and identity.
2. Decide which data remains in source during transition.
3. Decide which service owns catalog read data.
4. Decide how orders persist independently.
5. Record consistency and reconciliation requirements.

## Expected Outcome

You have a data migration and ownership plan that avoids permanent shared-database coupling.
