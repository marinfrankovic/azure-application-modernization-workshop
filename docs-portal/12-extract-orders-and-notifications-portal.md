# 12 - Extract Orders And Notifications - Azure Portal

## Objective

Plan order and notification modernization after the AKS migration baseline is running.

## Steps

1. Review the ordering flow in the AKS-hosted application.
2. For Track B, open Service Bus and confirm a queue or topic exists for notification events.
3. Submit a test order to the AKS-hosted app.
4. Inspect queue metrics, application telemetry, or pod logs as applicable.
5. For Track C, confirm identity, Key Vault, and network controls before any async integration is used.
6. Document source rollback path.

## Expected Outcome

The migrated application has a validated order path and a track-appropriate notification design.
