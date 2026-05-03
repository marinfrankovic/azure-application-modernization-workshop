# 05 - Track B: Enterprise - Azure Portal

## Objective

Create the enterprise AKS platform through the portal.

## Track Flow

[Open the Track B step-order diagram](../media/track-b-enterprise-flow.md).

## Steps

1. Open the Track B destination resource group and VNet created by the foundation script.
2. Create Log Analytics and Application Insights.
3. Create ACR with admin user disabled.
4. Create AKS in the destination VNet and grant it pull access to ACR.
5. Build and push the eShopOnWeb image to ACR.
6. Deploy eShopOnWeb to AKS.
7. Create Service Bus Standard namespace and a queue or topic for notifications.
8. Create APIM Developer tier and publish at least one route to the AKS backend.
9. Confirm telemetry reaches Application Insights.

## Validation Criteria

- AKS can pull from ACR and runs the workload.
- APIM routes to the AKS-hosted application.
- Service Bus can send and inspect or receive a test message.
- Application Insights shows application activity.

## Expected Outcome

Track B runs eShopOnWeb on AKS with registry, gateway, messaging, and observability integration.
