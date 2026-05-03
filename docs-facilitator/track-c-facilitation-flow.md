# Facilitator Flow - Track C Regulated AKS

## Mental Model

Facilitation follows the common-first model, then moves into regulated design validation before resources are created.

1. Confirm the common foundation.
2. Confirm the attendee selected Track C.
3. Require a private access plan before private AKS creation.
4. Let the attendee follow the Track C flow guide.
5. Use the complete solution guide only to unblock or validate.
6. Capture security, networking, secret, and Defender evidence.

## Common Facilitation Steps

1. Ask the attendee to open [CLI Track C Workshop Flow](../docs-cli/19-track-c-workshop-flow.md) or [Portal Track C Workshop Flow](../docs-portal/19-track-c-workshop-flow-portal.md).
2. Confirm prerequisites are complete.
3. Confirm the foundation report exists.
4. Confirm the source VM URL responds.
5. Confirm the Track C destination resource group initially contains only the regulated VNet foundation.
6. Ask the attendee to explain the private AKS access path before any private cluster is created.

## Track C Facilitation Steps

1. Validate the private control plane access plan.
2. Let the attendee create private or restricted AKS.
3. Let the attendee create or select the approved registry path.
4. Let the attendee configure registry pull access without embedded credentials.
5. Let the attendee create Key Vault with RBAC.
6. Let the attendee configure private endpoints and DNS where required.
7. Let the attendee enable Defender plans or document limitations.
8. Let the attendee containerize, build, push, and deploy eShopOnWeb.
9. Validate internal workload access and blocked public access.
10. Capture security evidence before cleanup.

## Complete Solution Reference

Use [Track C: Regulated AKS Complete Solution](track-c-regulated.md) when the attendee is blocked or when you need to verify target-state evidence.

## Evidence To Capture

- Source VM URL response.
- Regulated VNet-only starting state.
- Private AKS access path.
- AKS node and pod status.
- Registry access model.
- Key Vault RBAC and network settings.
- Defender plan status or documented limitation.
- Proof that unintended public access is blocked.
- Security exceptions and cleanup status.
