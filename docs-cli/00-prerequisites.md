# 00 - Prerequisites

## Objective

Prepare the tools and access needed to provision the workshop foundation and modernize eShopOnWeb from a VM-hosted monolith to AKS.

## Starting Assumption

The workshop scripts provision only the starting foundation:

- Source environment: a VNet and Linux VM running the non-containerized eShopOnWeb monolith.
- Destination environment: a VNet with track-appropriate subnets.

You create AKS and all supporting services yourself during the labs by using the Azure portal, Azure CLI, or a mix of both. No ready-made migration scripts, ARM/Bicep templates, or Terraform templates are provided for the target setup.

## Required Tools

- Azure CLI
- PowerShell 7+
- Git
- Docker Desktop or compatible container runtime
- kubectl
- .NET 8 SDK

## Azure Access

You need permission to create resource groups, VNets, VMs, public IP addresses, AKS, ACR, API Management, Service Bus, Key Vault, Log Analytics, Application Insights, Defender for Cloud settings, managed identities, and role assignments depending on the selected track.

## Steps

1. Sign in with `az login`.
2. Select the workshop subscription with `az account set --subscription <SUBSCRIPTION_ID_OR_NAME>`.
3. Clone the repository with submodules: `git submodule update --init --recursive`.
4. Confirm eShopOnWeb exists under `src/monolith/eShopOnWeb`.
5. Choose a short lowercase workshop prefix that is unique in your subscription, for example `appmod42`.
6. Run the foundation deployment script from the repository root:

```powershell
./infra/scripts/00-deploy-workshop.ps1 -Track A -Location westeurope -Prefix appmod42
```

Replace `A` with `B` or `C` for the enterprise or regulated track. You can run more than one track with a different prefix or destination resource group when you want to compare approaches.

## Expected Outcome

You have the tools, Azure access, and deployment command needed to create the source VM and destination VNet foundation.
