# Service Bus Notifications Queue

The workshop uses a queue named `notifications` to decouple order acceptance from notification delivery.

## Message Contract

```json
{
  "orderId": "string",
  "recipient": "customer@example.com",
  "channel": "email",
  "message": "Order accepted"
}
```

## Lab Use

- The orders service publishes a message after accepting an order.
- The notifications service receives the message and simulates delivery.
- Dead-letter handling is discussed as a production hardening topic.

## Recommended Production Enhancements

- Use managed identity with Azure Service Bus RBAC instead of connection strings.
- Use JSON serialization with schema validation.
- Add duplicate detection or idempotency in consumers.
- Monitor queue length and dead-letter count in Azure Monitor.
