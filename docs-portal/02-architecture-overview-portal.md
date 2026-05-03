# 02 - Architecture Overview - Azure Portal

## Objective

Understand the source VM, destination VNet foundation, and target track topology in the Azure portal.

## Steps

1. Locate the source resource group, VNet, VM, public IP, and NSG.
2. Open the source VM public URL and confirm eShopOnWeb responds.
3. Locate the destination resource group and VNet created for your selected track.
4. Review destination address space:
   - Track A: `10.20.0.0/16`.
   - Track B: `10.30.0.0/16`.
   - Track C: `10.40.0.0/16`.
5. Confirm the target platform services are not pre-created.
6. Plan where AKS, ingress, private endpoints, and service integrations will live.

## Expected Outcome

You can point to the pre-provisioned foundation and explain the services you will create for your selected track.
