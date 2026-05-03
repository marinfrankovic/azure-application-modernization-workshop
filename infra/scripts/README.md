# Workshop Scripts

These scripts follow the data-resilience workshop convention: infrastructure scripts live under `infra/scripts` and are run from the repository root or from this folder.

## Self-Service Setup

- `00-deploy-workshop.ps1` is the recommended attendee entry point. It deploys the source environment, one selected destination track, optional VNet peering, validation output, and a local deployment report under `output/`.
- `00-prepare-source.ps1` creates the source VNet and source application environment when you want to run the steps manually.

## Destination Tracks

- `01-deploy-track-a-simple.ps1` deploys the simple Container Apps destination.
- `02-deploy-track-b-enterprise.ps1` deploys the enterprise AKS destination.
- `03-deploy-track-c-regulated.ps1` deploys regulated private networking foundations.
- `04-peer-source-destination.ps1` peers source and destination VNets when the lab requires controlled cross-VNet connectivity.

## Operations

- `validate.ps1` lists deployed resources and runtime services.
- `cleanup.ps1` deletes workshop resource groups.

No script generates workshop passwords or static secrets. Access uses the signed-in Azure account and Azure RBAC. Deployment scripts fail fast on Azure CLI errors so the generated report records failed stages accurately. For Track B, use `az aks get-credentials` after deployment to connect to AKS.
