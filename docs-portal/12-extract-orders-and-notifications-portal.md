# 12 - Extract Orders And Notifications - Azure Portal

## Objective

Move order intake and notification delivery into destination services.

## Steps

1. Confirm orders, inventory, and notifications services are deployed.
2. For Track B, open Service Bus namespace and confirm queue `notifications`.
3. Submit a test order to destination orders endpoint.
4. Inspect queue metrics or service logs.
5. Confirm notification delivery is simulated or processed.
6. Document source rollback path.

## Expected Outcome

The destination order workflow works independently enough for migration testing.
