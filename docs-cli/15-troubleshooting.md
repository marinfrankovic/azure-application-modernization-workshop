# 15 - Troubleshooting

## Objective

Resolve common workshop failures quickly.

## Common Issues

## Source URL Does Not Respond

Confirm `00-deploy-workshop.ps1` or `00-prepare-source.ps1` completed successfully. Check the VM public IP, NSG rules, and the VM service status with `systemctl status eshop-web --no-pager`.

## VNet Peering Fails

Check that source and destination address spaces do not overlap. Confirm you have Network Contributor permissions on both VNets.

## VM Deployment Succeeds But App Is Down

SSH to the VM and inspect `cloud-init` logs, `journalctl -u eshop-web`, and whether the app is listening on port 80.

## AKS Pod Does Not Start

Check image name, image pull permissions, container port, environment variables, and pod events.

## AKS Cannot Pull Image

Confirm AKS kubelet identity has AcrPull on the destination ACR.

## APIM Route Returns 404

Check backend URL, route path, and rewrite policy.

## Service Bus Message Is Not Processed

Check queue name, sender/receiver permissions, and dead-letter count.

## Key Vault Access Denied

Wait for RBAC propagation, confirm the managed identity or user assignment, and check whether network restrictions block the request.

## Expected Outcome

You can identify whether failures are caused by source readiness, destination deployment, networking, routing, or service code.
