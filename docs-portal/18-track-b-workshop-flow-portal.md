# 18 - Track B Workshop Flow - Azure Portal

## Objective

Follow the portal-oriented document sequence for Track B: Enterprise AKS migration.

## Mental Model

Every track starts with the common foundation. Track B then adds enterprise platform services around the AKS-hosted application.

Track B is the portal path for platform integration: create ACR, AKS, APIM, Service Bus, Application Insights, and Log Analytics, then prove that routing, messaging, and observability work.

## Common Steps For All Tracks

1. Read [00 - Prerequisites - Azure Portal](00-prerequisites-portal.md).
2. Read [01 - Workshop Agenda - Azure Portal](01-workshop-agenda-portal.md).
3. Read [02 - Architecture Overview - Azure Portal](02-architecture-overview-portal.md).
4. Complete [03 - Prepare Source Environment - Azure Portal](03-prepare-source-environment-portal.md) with Track B selected.
5. Complete [08 - Validate Source Baseline - Azure Portal](08-validate-source-baseline-portal.md).
6. Keep the generated deployment report open.

## Track B Steps

1. Read [05 - Track B: Enterprise - Azure Portal](05-track-b-enterprise-portal.md).
2. Open [Track B: Enterprise AKS Flow](../media/track-b-enterprise-flow.md).
3. Create Log Analytics and Application Insights.
4. Create ACR with admin user disabled.
5. Create AKS in the Track B destination VNet.
6. Grant AKS pull access to ACR.
7. Read [10 - Containerize And Stage Services - Azure Portal](10-containerize-and-stage-services-portal.md).
8. Build and push the eShopOnWeb image to ACR.
9. Deploy eShopOnWeb to AKS.
10. Create Service Bus and a notification queue or topic.
11. Create APIM and publish at least one route to the AKS backend.
12. Generate test traffic.
13. Validate APIM, Service Bus, telemetry, and AKS health.

## Optional Modernization Steps

1. Read [09 - Bounded Contexts - Azure Portal](09-bounded-contexts-portal.md).
2. Read [11 - Extract Catalog - Azure Portal](11-extract-catalog-portal.md).
3. Read [12 - Extract Orders And Notifications - Azure Portal](12-extract-orders-and-notifications-portal.md).
4. Read [13 - Data Decomposition - Azure Portal](13-data-decomposition-portal.md).

## Operations And Cleanup

1. Read [14 - Operational Runbooks - Azure Portal](14-operational-runbooks-portal.md).
2. Use [15 - Troubleshooting - Azure Portal](15-troubleshooting-portal.md) if validation fails.
3. Review costs for AKS, APIM, Service Bus, ACR, and monitoring.
4. Clean up the source and Track B destination resource groups.
