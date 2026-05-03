# 00 - Prerequisites

## Objective

Prepare the tools and access needed to deploy and run the Azure source-to-destination application modernization workshop in your own Azure environment.

## Starting Assumption

You deploy both the source environment and one destination track yourself. The source environment contains eShopOnWeb running in a source VNet. The deployment script records the source resource group name, source VNet name, source application URL, Azure region, destination resource group, destination VNet, and access notes in a local report under `output/`.

## Required Tools

- Azure CLI
- PowerShell 7+
- Git
- Docker Desktop or compatible container runtime
- kubectl
- .NET 8 SDK
- Python 3.11+

## Azure Access

You need permission to create resource groups, VNets, Container Apps, AKS, ACR, API Management, Service Bus, Key Vault, Log Analytics, and role assignments depending on the selected track.

## Steps

1. Sign in with `az login`.
2. Select the workshop subscription with `az account set --subscription <SUBSCRIPTION_ID_OR_NAME>`.
3. Clone the repository with submodules: `git submodule update --init --recursive`.
4. Confirm eShopOnWeb exists under `src/monolith/eShopOnWeb`.
5. Choose a short lowercase workshop prefix that is unique in your subscription, for example `appmod42`.
6. Run the self-service deployment script from the repository root:

```powershell
./infra/scripts/00-deploy-workshop.ps1 -Track A -Location westeurope -Prefix appmod42
```

Replace `A` with `B` or `C` for the enterprise or regulated track.

## Expected Outcome

You have the tools, Azure access, and deployment command needed to create the full workshop environment without external dependencies.
