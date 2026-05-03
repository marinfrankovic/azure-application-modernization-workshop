# 06 - Track C: Regulated - Azure Portal

## Objective

Create a regulated AKS target through the portal.

## Track Flow

[Open the Track C step-order diagram](../media/track-c-regulated-flow.md).

## Steps

1. Open the Track C destination resource group and VNet created by the foundation script.
2. Create private or restricted AKS in the destination VNet.
3. Create Key Vault with RBAC authorization and restricted network access.
4. Create or select an approved registry path for the eShopOnWeb image.
5. Configure private endpoints and private DNS zones where your design requires them.
6. Enable Defender plans for Containers, Key Vault, and relevant resources where permitted.
7. Deploy eShopOnWeb to AKS without storing secrets in manifests.
8. Document policy exceptions or approvals.

## Validation Criteria

- AKS control plane and workload access follow the selected private or restricted design.
- Key Vault access works through approved identity and network paths.
- Defender settings or documented constraints are visible.
- The workload is reachable only through the approved route.

## Expected Outcome

Track C runs eShopOnWeb on AKS with regulated networking, secrets, and security controls.
