# Workshop Scripts

These scripts follow the data-resilience workshop convention: infrastructure scripts live under `infra/scripts` and are run from the repository root or from this folder.

## Facilitator Setup

- `00-prepare-source.ps1` creates the prepared source VNet and source application environment before attendees start.

## Attendee Destination Tracks

- `01-deploy-track-a-simple.ps1` deploys the simple Container Apps destination.
- `02-deploy-track-b-enterprise.ps1` deploys the enterprise AKS destination.
- `03-deploy-track-c-regulated.ps1` deploys regulated private networking foundations.
- `04-peer-source-destination.ps1` peers source and destination VNets when the lab requires controlled cross-VNet connectivity.

## Operations

- `validate.ps1` lists deployed resources and runtime services.
- `cleanup.ps1` deletes workshop resource groups.
