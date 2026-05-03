# Workshop Scripts

These scripts provision only the workshop foundation and are run from the repository root or from this folder.

## Self-Service Setup

- `00-deploy-workshop.ps1` is the recommended attendee entry point. It deploys the source VM environment, one selected destination VNet foundation, optional VNet peering, validation output, and a local deployment report under `output/`.
- `00-prepare-source.ps1` creates the source VNet and Linux VM running non-containerized eShopOnWeb when you want to run the steps manually.

## Destination Tracks

- `01-deploy-track-a-simple.ps1` deploys the Track A destination VNet only.
- `02-deploy-track-b-enterprise.ps1` deploys the Track B destination VNet only.
- `03-deploy-track-c-regulated.ps1` deploys the Track C destination VNet only.
- `04-peer-source-destination.ps1` peers source and destination VNets when the lab requires controlled cross-VNet connectivity.

Attendees create AKS and all track-specific services during the exercises by using the Azure portal, Azure CLI, or both. These scripts do not create AKS, ACR, APIM, Service Bus, Application Insights, Key Vault, or Defender configuration.

## Operations

- `validate.ps1` lists deployed resources and runtime services.
- `cleanup.ps1` deletes workshop resource groups.

No script generates workshop passwords or static secrets. Access uses the signed-in Azure account, SSH key authentication for the source VM, and Azure RBAC. Deployment scripts fail fast on Azure CLI errors so the generated report records failed stages accurately.
