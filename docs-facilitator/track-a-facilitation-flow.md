# Facilitator Flow - Track A Simple AKS

## Mental Model

Facilitation follows the same structure as the attendee path:

1. Confirm the common foundation.
2. Confirm the attendee selected Track A.
3. Let the attendee follow the Track A flow guide.
4. Use the complete solution guide only to unblock or validate.
5. Capture evidence and cleanup status.

## Common Facilitation Steps

1. Ask the attendee to open [CLI Track A Workshop Flow](../docs-cli/17-track-a-workshop-flow.md) or [Portal Track A Workshop Flow](../docs-portal/17-track-a-workshop-flow-portal.md).
2. Confirm prerequisites are complete.
3. Confirm the foundation report exists.
4. Confirm the source VM URL responds.
5. Confirm the Track A destination resource group initially contains only the destination VNet.
6. Ask the attendee to explain their registry choice and exposure choice before creating AKS.

## Track A Facilitation Steps

1. Let the attendee create AKS in the destination VNet.
2. Let the attendee containerize eShopOnWeb.
3. Let the attendee build and push the image.
4. Let the attendee create Kubernetes deployment and service resources.
5. Let the attendee expose the workload.
6. Validate the AKS endpoint with the attendee.
7. Compare the AKS app with the source VM app.

## Complete Solution Reference

Use [Track A: Simple AKS Complete Solution](track-a-simple.md) when the attendee is blocked or when you need to verify target-state evidence.

## Evidence To Capture

- Source VM URL response.
- Destination VNet-only starting state.
- AKS node and pod status.
- Registry image tag.
- Workload endpoint.
- Rollback note.
- Cleanup status.
