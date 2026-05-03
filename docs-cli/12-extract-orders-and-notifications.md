# 12 - Extract Orders And Notifications

## Objective

Plan order and notification modernization after the VM-to-AKS migration.

## Architecture Explanation

Orders coordinate catalog and inventory. Notifications are better handled asynchronously. Track B requires Service Bus integration, while Track C requires private access, managed identity, and governed secret handling.

## Azure Services Used

- AKS.
- Service Bus for Track B and optional regulated async integration.
- APIM for Track B routing where selected.
- Key Vault and managed identity for regulated secret handling.

## Steps

1. Review the eShopOnWeb ordering flow.
2. Identify where notifications are currently synchronous, embedded, or tightly coupled.
3. For Track B, create and test a Service Bus queue or topic for notification events.
4. Define how the AKS-hosted application would publish an order notification event.
5. For Track C, document the managed identity, RBAC, Key Vault, and network controls needed before messages can flow.
6. Submit a test order against the AKS-hosted app and record observed behavior.
7. Record rollback path to source ordering.

## Expected Outcome

You have a validated order path and a clear async notification design for your selected track.
