# 03 - Prepare Source Environment - Azure Portal

## Objective

Validate the pre-provisioned source VM and destination VNet in your own Azure subscription.

## Steps

1. Open the generated deployment report under `output/`.
2. In the portal, open the source resource group.
3. Confirm the VM, public IP, NSG, NIC, and source VNet exist.
4. Browse the source eShopOnWeb URL from the report.
5. Open the destination resource group and confirm it contains only networking resources.
6. Record source app URL, source resource group, destination resource group, destination VNet, and region in your worksheet.

## Expected Outcome

The VM-hosted source is ready, and the destination VNet is ready for manual AKS target creation.
