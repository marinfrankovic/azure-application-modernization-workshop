# 15 - Troubleshooting

## Objective

Resolve common workshop failures quickly.

## Common Issues

## Source URL Does Not Respond

Confirm the facilitator prepared the source environment and that source app status is healthy.

## VNet Peering Fails

Check that source and destination address spaces do not overlap. Confirm you have Network Contributor permissions on both VNets.

## Container App Does Not Start

Check image name, port, and Container Apps logs.

## AKS Cannot Pull Image

Confirm AKS kubelet identity has AcrPull on the destination ACR.

## APIM Route Returns 404

Check backend URL, route path, and rewrite policy.

## Service Bus Message Is Not Processed

Check queue name, sender/receiver permissions, and dead-letter count.

## Key Vault Access Denied

Wait for RBAC propagation and confirm the correct object ID was used.

## Expected Outcome

You can identify whether failures are caused by source readiness, destination deployment, networking, routing, or service code.
