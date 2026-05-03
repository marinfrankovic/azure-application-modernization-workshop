# Facilitator Flow - Track B Enterprise AKS

## Mental Model

Facilitation follows the same common-first model, then expands into enterprise platform validation.

1. Confirm the common foundation.
2. Confirm the attendee selected Track B.
3. Let the attendee follow the Track B flow guide.
4. Use the complete solution guide only to unblock or validate.
5. Capture evidence for AKS, ACR, APIM, Service Bus, and telemetry.

## Common Facilitation Steps

1. Ask the attendee to open [CLI Track B Workshop Flow](../docs-cli/18-track-b-workshop-flow.md) or [Portal Track B Workshop Flow](../docs-portal/18-track-b-workshop-flow-portal.md).
2. Confirm prerequisites are complete.
3. Confirm the foundation report exists.
4. Confirm the source VM URL responds.
5. Confirm the Track B destination resource group initially contains only the destination VNet.
6. Ask the attendee to explain how traffic, images, messages, and telemetry will flow before creating services.

## Track B Facilitation Steps

1. Let the attendee create Log Analytics and Application Insights.
2. Let the attendee create ACR with admin user disabled.
3. Let the attendee create AKS in the destination VNet.
4. Let the attendee grant AKS pull access to ACR.
5. Let the attendee containerize, build, push, and deploy eShopOnWeb.
6. Let the attendee create Service Bus and a notification queue or topic.
7. Let the attendee create APIM and publish a route to the AKS backend.
8. Generate traffic and validate AKS, APIM, Service Bus, and telemetry.

## Complete Solution Reference

Use [Track B: Enterprise AKS Complete Solution](track-b-enterprise.md) when the attendee is blocked or when you need to verify target-state evidence.

## Evidence To Capture

- Source VM URL response.
- Destination VNet-only starting state.
- ACR image tag and admin-disabled setting.
- AKS node, pod, and service status.
- APIM route test.
- Service Bus test message.
- Application Insights or Azure Monitor evidence.
- Production hardening notes.
- Cleanup status.
