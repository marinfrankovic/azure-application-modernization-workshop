# 17 - Track A Workshop Flow - Azure Portal

## Objective

Follow the portal-oriented document sequence for Track A: Simple AKS migration.

## Mental Model

Every track starts the same way:

1. Prepare your subscription and tools.
2. Understand the workshop model and architecture.
3. Deploy the shared foundation with the workshop script.
4. Validate the source VM baseline.
5. Select your track.
6. Use the portal for track-specific Azure resources and validation.

Track A is the simplest path: create AKS, containerize eShopOnWeb, deploy it, expose it, and validate the migrated app.

## Common Steps For All Tracks

1. Read [00 - Prerequisites - Azure Portal](00-prerequisites-portal.md).
2. Read [01 - Workshop Agenda - Azure Portal](01-workshop-agenda-portal.md).
3. Read [02 - Architecture Overview - Azure Portal](02-architecture-overview-portal.md).
4. Complete [03 - Prepare Source Environment - Azure Portal](03-prepare-source-environment-portal.md) with Track A selected.
5. Complete [08 - Validate Source Baseline - Azure Portal](08-validate-source-baseline-portal.md).
6. Keep the generated deployment report open.

## Track A Steps

1. Read [04 - Track A: Simple AKS - Azure Portal](04-track-a-container-apps-portal.md).
2. Open [Track A: Simple AKS Flow](../media/track-a-simple-flow.md).
3. In the portal, create AKS in the Track A destination VNet.
4. Create or select a registry and configure AKS pull access.
5. Read [10 - Containerize And Stage Services - Azure Portal](10-containerize-and-stage-services-portal.md).
6. Build and push the eShopOnWeb image.
7. Use Cloud Shell, Kubernetes resources, or local `kubectl` to create the deployment and service.
8. Browse the AKS endpoint.
9. Validate Track A criteria in [04 - Track A: Simple AKS - Azure Portal](04-track-a-container-apps-portal.md).

## Optional Modernization Steps

1. Read [09 - Bounded Contexts - Azure Portal](09-bounded-contexts-portal.md).
2. Read [11 - Extract Catalog - Azure Portal](11-extract-catalog-portal.md).
3. Read [12 - Extract Orders And Notifications - Azure Portal](12-extract-orders-and-notifications-portal.md).
4. Read [13 - Data Decomposition - Azure Portal](13-data-decomposition-portal.md).

## Operations And Cleanup

1. Read [14 - Operational Runbooks - Azure Portal](14-operational-runbooks-portal.md).
2. Use [15 - Troubleshooting - Azure Portal](15-troubleshooting-portal.md) if validation fails.
3. Clean up the source and Track A destination resource groups.
