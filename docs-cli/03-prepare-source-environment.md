# 03 - Prepare Source Environment

## Objective

Provision and validate the VM-hosted eShopOnWeb source environment and the selected destination VNet foundation.

## What The Script Creates

The foundation deployment creates:

- Source resource group.
- Source VNet and subnet.
- Linux VM running non-containerized eShopOnWeb.
- Public IP and NSG rules for HTTP and SSH access to the lab VM.
- Destination resource group.
- Destination VNet and subnets for the selected track.
- Optional VNet peering between source and destination.
- Local deployment report under `output/`.

The script does not create AKS or any target platform services.

## Steps

1. Deploy a selected track foundation:

```powershell
./infra/scripts/00-deploy-workshop.ps1 -Track A -Location westeurope -Prefix appmod42
```

2. Open the generated report in `output/`.
3. Record the source VM name, source application URL, SSH command, source resource group, destination resource group, and destination VNet name.
4. Browse the source application URL.
5. Validate the source VM service if needed:

```powershell
ssh azureuser@<SOURCE_PUBLIC_IP>
systemctl status eshop-web --no-pager
```

6. Confirm the destination resource group contains only networking resources before you start the target build.

## Expected Outcome

The source VM serves eShopOnWeb, and the destination VNet is ready for you to create AKS and track-specific Azure services manually.
