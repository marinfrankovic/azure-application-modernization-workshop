# 19 - Track C Workshop Flow - Azure Portal

## Objective

Follow the portal-oriented document sequence for Track C: Regulated AKS migration.

## Mental Model

Every track starts with the common foundation. Track C then adds private access, governed secrets, and security posture validation.

Track C is the regulated portal path: define the private access model first, then create private AKS, Key Vault, Defender posture, private endpoints, and controlled workload access.

## Common Steps For All Tracks

1. Read [00 - Prerequisites - Azure Portal](00-prerequisites-portal.md).
2. Read [01 - Workshop Agenda - Azure Portal](01-workshop-agenda-portal.md).
3. Read [02 - Architecture Overview - Azure Portal](02-architecture-overview-portal.md).
4. Complete [03 - Prepare Source Environment - Azure Portal](03-prepare-source-environment-portal.md) with Track C selected.
5. Complete [08 - Validate Source Baseline - Azure Portal](08-validate-source-baseline-portal.md).
6. Keep the generated deployment report open.

## Track C Steps

1. Read [06 - Track C: Regulated - Azure Portal](06-track-c-regulated-portal.md).
2. Open [Track C: Regulated AKS Flow](../media/track-c-regulated-flow.md).
3. Decide how you will access the private AKS control plane.
4. Create private or restricted AKS in the Track C destination VNet.
5. Create or select an approved image registry path.
6. Configure registry pull access for AKS without embedded credentials.
7. Create Key Vault with RBAC authorization.
8. Configure private endpoints and private DNS where required.
9. Enable Defender plans or document subscription limitations.
10. Read [10 - Containerize And Stage Services - Azure Portal](10-containerize-and-stage-services-portal.md).
11. Build and push the eShopOnWeb image through the approved path.
12. Deploy eShopOnWeb to private AKS.
13. Validate private workload access and blocked public access.
14. Collect Key Vault, Defender, and network evidence.

## Optional Modernization Steps

1. Read [09 - Bounded Contexts - Azure Portal](09-bounded-contexts-portal.md).
2. Read [11 - Extract Catalog - Azure Portal](11-extract-catalog-portal.md).
3. Read [12 - Extract Orders And Notifications - Azure Portal](12-extract-orders-and-notifications-portal.md).
4. Read [13 - Data Decomposition - Azure Portal](13-data-decomposition-portal.md).

## Operations And Cleanup

1. Read [14 - Operational Runbooks - Azure Portal](14-operational-runbooks-portal.md).
2. Use [15 - Troubleshooting - Azure Portal](15-troubleshooting-portal.md) if validation fails.
3. Collect security evidence before cleanup.
4. Clean up the source and Track C destination resource groups.
