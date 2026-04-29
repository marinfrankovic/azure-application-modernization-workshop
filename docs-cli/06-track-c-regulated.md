# 06 - Track C: Regulated Private Destination

## Objective

Create regulated destination foundations with private networking, Key Vault, and Defender guidance.

## Architecture Explanation

Track C is for teams that must prove network isolation, secret governance, and security posture before application cutover. The lab deploys a private destination VNet, Key Vault with public access disabled, private-ready ACR, and monitoring foundations. Defender enablement is performed through Azure security configuration because it is often subscription-scoped.

## Azure Services Used

- Destination VNet with workload and private endpoint subnets.
- Key Vault with RBAC and public access disabled.
- ACR with public access disabled.
- Log Analytics.
- Microsoft Defender for Cloud configuration guidance.

## Steps

1. Get your object ID:

```powershell
az ad signed-in-user show --query id -o tsv
```

2. Deploy regulated foundations:

```powershell
./infra/scripts/03-deploy-track-c-regulated.ps1 -DestinationResourceGroupName rg-appmod-dest-c -Location westeurope -Prefix appmodc -AdminObjectId <OBJECT_ID>
```

3. Enable Defender plans appropriate for the workshop subscription, such as Containers and Key Vault.
4. Add private endpoints and DNS zones where required by your organization's policy.
5. Document how source-to-destination traffic is approved.

## Expected Outcome

A regulated destination foundation exists before decomposed services are admitted.
