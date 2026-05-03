# 18 - Track B Workshop Flow

## Objective

Follow the CLI-oriented document sequence for Track B: Enterprise AKS migration.

## Mental Model

Every track starts with the same foundation and source validation. Track B then adds enterprise platform services around the AKS-hosted application.

Track B is the platform integration path: create ACR, AKS, APIM, Service Bus, Application Insights, and Log Analytics, then prove that routing, messaging, and observability work.

## Common Steps For All Tracks

1. Read [00 - Prerequisites](00-prerequisites.md).
2. Read [01 - Workshop Agenda](01-workshop-agenda.md).
3. Read [02 - Architecture Overview](02-architecture-overview.md).
4. Complete [03 - Prepare Source Environment](03-prepare-source-environment.md) with Track B selected.
5. Complete [08 - Validate Source Baseline](08-validate-source-baseline.md).
6. Keep the generated deployment report open. You need the source URL, source resource group, destination resource group, destination VNet, and subnet names.

## Track B Steps

1. Read [05 - Track B: Enterprise AKS Migration](05-track-b-enterprise.md).
2. Review [Track B: Enterprise AKS Flow](../media/track-b-enterprise-flow.md).
3. Create Log Analytics and Application Insights.
4. Create ACR with admin user disabled.
5. Create AKS in the Track B destination VNet.
6. Grant AKS pull access to ACR.
7. Read [10 - Containerize And Stage Services](10-containerize-and-stage-services.md).
8. Containerize eShopOnWeb and push the image to ACR.
9. Deploy eShopOnWeb to AKS.
10. Create Service Bus and a notification queue or topic.
11. Create APIM and publish at least one route to the AKS backend.
12. Generate test traffic through the AKS endpoint and APIM endpoint.
13. Validate telemetry in Application Insights or Azure Monitor.
14. Validate the Track B criteria in [05 - Track B: Enterprise AKS Migration](05-track-b-enterprise.md).

## Optional Modernization Steps

Use these after the Track B platform is healthy:

1. Read [09 - Bounded Contexts](09-bounded-contexts.md).
2. Read [11 - Extract Catalog](11-extract-catalog.md).
3. Read [12 - Extract Orders And Notifications](12-extract-orders-and-notifications.md).
4. Read [13 - Data Decomposition](13-data-decomposition.md).

## Operations And Cleanup

1. Read [14 - Operational Runbooks](14-operational-runbooks.md).
2. Review [16 - Cost Examples](16-cost-examples.md), especially APIM, AKS, and Service Bus cost notes.
3. Use [15 - Troubleshooting](15-troubleshooting.md) if validation fails.
4. Clean up the source and Track B destination resource groups.

## Completion Checklist

- Source VM URL responds.
- Destination initially contained only the VNet foundation.
- AKS is created in the destination VNet.
- ACR contains the eShopOnWeb image and AKS can pull it.
- Pods and service are healthy.
- APIM route reaches the AKS backend.
- Service Bus accepts a test message.
- Application Insights or Azure Monitor shows activity.
- Platform decisions and production hardening notes are recorded.
