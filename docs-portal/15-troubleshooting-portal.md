# 15 - Troubleshooting - Azure Portal

## Objective

Resolve portal-based workshop issues.

## Checks

- Source app unhealthy: verify VM status, public IP, NSG rules, and `eshop-web` service health over SSH.
- VNet peering disconnected: check both peerings and address spaces.
- AKS pod pending: inspect node pool capacity and events.
- AKS image pull failing: check registry permissions and network access.
- APIM backend failing: check backend URL and operation path.
- Service Bus queue not receiving messages: inspect queue metrics and shared access/RBAC settings.
- Key Vault access denied: check RBAC assignments and network access.

## Expected Outcome

You can isolate problems by source, destination, network, gateway, service, or security layer.
