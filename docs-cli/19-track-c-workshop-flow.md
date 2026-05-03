# 19 - Track C Workshop Flow

## Objective

Follow the CLI-oriented document sequence for Track C: Regulated AKS migration.

## Mental Model

Every track starts with the same foundation and source validation. Track C then adds private access, governed secrets, and security posture validation.

Track C is the regulated path: decide how private access works before creating private AKS, then validate that secrets, network exposure, and Defender posture match the design.

## Common Steps For All Tracks

1. Read [00 - Prerequisites](00-prerequisites.md).
2. Read [01 - Workshop Agenda](01-workshop-agenda.md).
3. Read [02 - Architecture Overview](02-architecture-overview.md).
4. Complete [03 - Prepare Source Environment](03-prepare-source-environment.md) with Track C selected.
5. Complete [08 - Validate Source Baseline](08-validate-source-baseline.md).
6. Keep the generated deployment report open. You need the source URL, source resource group, destination resource group, destination VNet, and regulated subnet names.

## Track C Steps

1. Read [06 - Track C: Regulated AKS Migration](06-track-c-regulated.md).
2. Review [Track C: Regulated AKS Flow](../media/track-c-regulated-flow.md).
3. Decide how you will access the private AKS control plane, such as `az aks command invoke`, a jump host, VPN, or an approved network path.
4. Create private or restricted AKS in the Track C destination VNet.
5. Create or select an approved image registry path.
6. Configure registry pull access for AKS without embedding credentials.
7. Create Key Vault with RBAC authorization.
8. Configure private endpoints and DNS where required by your design.
9. Enable Defender plans or document subscription limitations.
10. Read [10 - Containerize And Stage Services](10-containerize-and-stage-services.md).
11. Containerize eShopOnWeb and push the image through the approved path.
12. Deploy eShopOnWeb to private AKS.
13. Expose the workload only through the approved private or controlled ingress path.
14. Validate the Track C criteria in [06 - Track C: Regulated AKS Migration](06-track-c-regulated.md).

## Optional Modernization Steps

Use these after the regulated platform is healthy:

1. Read [09 - Bounded Contexts](09-bounded-contexts.md).
2. Read [11 - Extract Catalog](11-extract-catalog.md).
3. Read [12 - Extract Orders And Notifications](12-extract-orders-and-notifications.md).
4. Read [13 - Data Decomposition](13-data-decomposition.md).

## Operations And Cleanup

1. Read [14 - Operational Runbooks](14-operational-runbooks.md).
2. Review [16 - Cost Examples](16-cost-examples.md), especially AKS, private endpoints, Defender, and Key Vault notes.
3. Use [15 - Troubleshooting](15-troubleshooting.md) if validation fails.
4. Collect security evidence before cleanup.
5. Clean up the source and Track C destination resource groups.

## Completion Checklist

- Source VM URL responds.
- Destination initially contained only the regulated VNet foundation.
- Private or restricted AKS access path is defined and tested.
- AKS workload runs without embedded secrets.
- Key Vault access uses approved identity and network paths.
- Defender status or limitation is documented.
- Public access is disabled or explicitly justified.
- Application access works only through the approved route.
- Security exceptions and cleanup plan are recorded.
