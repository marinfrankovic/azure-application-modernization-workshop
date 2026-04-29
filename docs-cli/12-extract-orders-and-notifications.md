# 12 - Extract Orders And Notifications

## Objective

Decompose order intake and notification delivery into destination services.

## Architecture Explanation

Orders coordinate catalog and inventory. Notifications are better handled asynchronously. Track B uses Service Bus as the main eventing path, while Track A can use direct HTTP during the simple lab and Track C adds private and RBAC controls.

## Azure Services Used

- Orders service.
- Inventory service.
- Notifications service.
- Service Bus in Track B and regulated Track C.
- APIM or Container Apps ingress for routing.

## Steps

1. Review eShopOnWeb ordering flow.
2. Deploy orders, inventory, and notifications services.
3. For Track B, confirm Service Bus queue `notifications` exists.
4. Submit a test order to the destination orders endpoint.
5. Process the notification event or inspect the simulated delivery.
6. Record rollback path to source ordering.

## Expected Outcome

The destination can accept an order workflow and decouple notification delivery.
