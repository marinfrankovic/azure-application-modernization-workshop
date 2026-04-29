# 05 - Track B: Enterprise - Azure Portal

## Objective

Create the AKS, APIM, and Service Bus destination through the portal.

## Steps

1. Create resource group `rg-appmod-dest-b`.
2. Create destination VNet `10.30.0.0/16` with AKS and APIM subnets.
3. Create Log Analytics and Application Insights.
4. Create ACR with admin user disabled.
5. Create AKS and attach it to the destination VNet.
6. Grant AKS AcrPull on ACR.
7. Create Service Bus Standard namespace and queue `notifications`.
8. Create APIM Developer tier and workshop API routes.

## Expected Outcome

Track B enterprise destination is ready for service deployment and routing.
