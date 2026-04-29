# AKS Manifests

These manifests support the workshop deployment scripts.

- `monolith.yaml` deploys the eShopOnWeb web container behind a LoadBalancer service.
- `services.yaml` deploys the extracted catalog, inventory, orders, and notifications services.

The scripts replace `REPLACE_ACR_LOGIN_SERVER` with the ACR login server discovered from the resource group.

For production, replace LoadBalancer services with ingress, add readiness probes, configure managed identity, and store secrets through Key Vault CSI Driver or workload identity.
