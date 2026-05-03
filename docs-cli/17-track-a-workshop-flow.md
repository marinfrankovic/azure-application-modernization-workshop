# 17 - Track A Workshop Flow

## Objective

Follow the CLI-oriented document sequence for Track A: Simple AKS migration.

## Mental Model

Every track starts the same way:

1. Prepare your tools and subscription.
2. Understand the workshop model and architecture.
3. Deploy the shared foundation: source VM plus destination VNet.
4. Validate the source VM baseline.
5. Select your track.
6. Follow the track-specific build, migration, validation, and cleanup path.

Track A is the shortest path: create AKS, containerize eShopOnWeb, deploy it, expose it, and validate the migrated application.

## Common Steps For All Tracks

1. Read [00 - Prerequisites](00-prerequisites.md).
2. Read [01 - Workshop Agenda](01-workshop-agenda.md).
3. Read [02 - Architecture Overview](02-architecture-overview.md).
4. Complete [03 - Prepare Source Environment](03-prepare-source-environment.md) with Track A selected.
5. Complete [08 - Validate Source Baseline](08-validate-source-baseline.md).
6. Keep the generated deployment report open. You need the source URL, source resource group, destination resource group, destination VNet, and subnet names.

## Track A Steps

1. Read [04 - Track A: Simple AKS Migration](04-track-a-container-apps.md).
2. Review [Track A: Simple AKS Flow](../media/track-a-simple-flow.md).
3. Create AKS in the Track A destination VNet.
4. Read [10 - Containerize And Stage Services](10-containerize-and-stage-services.md).
5. Containerize eShopOnWeb from `src/monolith/eShopOnWeb`.
6. Build and push the image to your selected registry.
7. Create Kubernetes deployment and service resources.
8. Deploy eShopOnWeb to AKS.
9. Expose the workload with a service or ingress.
10. Re-run [08 - Validate Source Baseline](08-validate-source-baseline.md) to confirm the source VM remains available as rollback.
11. Validate the Track A criteria in [04 - Track A: Simple AKS Migration](04-track-a-container-apps.md).

## Optional Modernization Steps

Use these after the basic Track A migration succeeds:

1. Read [09 - Bounded Contexts](09-bounded-contexts.md).
2. Read [11 - Extract Catalog](11-extract-catalog.md).
3. Read [12 - Extract Orders And Notifications](12-extract-orders-and-notifications.md).
4. Read [13 - Data Decomposition](13-data-decomposition.md).

## Operations And Cleanup

1. Read [14 - Operational Runbooks](14-operational-runbooks.md).
2. Review [16 - Cost Examples](16-cost-examples.md).
3. Use [15 - Troubleshooting](15-troubleshooting.md) if validation fails.
4. Clean up the source and Track A destination resource groups.

## Completion Checklist

- Source VM URL responds.
- Destination initially contained only the VNet foundation.
- AKS is created in the destination VNet.
- eShopOnWeb image is built and pushed.
- AKS pods are running.
- AKS endpoint returns the application.
- Rollback to the source VM is understood.
- Cleanup plan is documented.
