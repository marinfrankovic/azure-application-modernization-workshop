# 00 - Prerequisites

## Objective

Prepare the tools and access needed for an Azure source-to-destination application modernization workshop.

## Starting Assumption

The facilitator has already prepared the source environment in Azure. The source environment contains eShopOnWeb running in a source VNet. Attendees receive the source resource group name, source VNet name, source application URL, Azure region, and workshop prefix.

## Required Tools

- Azure CLI
- PowerShell 7+
- Git
- Docker Desktop or compatible container runtime
- kubectl
- .NET 8 SDK
- Python 3.11+

## Azure Access

You need permission to create resource groups, VNets, Container Apps, AKS, ACR, API Management, Service Bus, Key Vault, Log Analytics, and role assignments depending on selected track.

## Steps

1. Sign in with `az login`.
2. Select the workshop subscription with `az account set --subscription <SUBSCRIPTION_ID_OR_NAME>`.
3. Clone the repository with submodules: `git submodule update --init --recursive`.
4. Confirm eShopOnWeb exists under `src/monolith/eShopOnWeb`.
5. Confirm the source application URL opens before creating the destination environment.

## Expected Outcome

You are ready to build a destination environment and decompose the monolith into it.
