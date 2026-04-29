# 06 - Track C: Regulated - Azure Portal

## Objective

Create regulated destination foundations through the portal.

## Steps

1. Create resource group `rg-appmod-dest-c`.
2. Create destination VNet `10.40.0.0/16`.
3. Create workload and private endpoint subnets.
4. Create Key Vault with RBAC authorization and public network access disabled.
5. Create ACR with admin user disabled and public access disabled where policy allows.
6. Add private endpoints and private DNS zones as required.
7. Enable Defender plans for Containers, Key Vault, and relevant resources.
8. Document policy exceptions or approvals.

## Expected Outcome

Track C has private networking and security foundations for regulated modernization.
