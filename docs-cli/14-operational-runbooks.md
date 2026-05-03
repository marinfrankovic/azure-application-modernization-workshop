# 14 - Operational Runbooks

## Objective

Define day-two operations for the decomposed destination environment.

## Architecture Explanation

Destination services introduce new operational responsibilities: routing, queues, service health, secrets, image supply chain, and source-to-destination dependencies.

## Azure Services Used

- Log Analytics.
- Application Insights.
- Service Bus metrics.
- AKS diagnostics.
- Key Vault diagnostics.

## Steps

1. Create a health check runbook for each service.
2. Create a rollback runbook for catalog route changes.
3. Create a queue backlog runbook for notifications.
4. Create a secret rotation runbook for regulated environments.
5. Add escalation owners for source and destination teams.

## Expected Outcome

You have practical runbooks for operating the destination services after extraction.
