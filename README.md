# Azure Application Modernization Workshop

A hands-on workshop for modernizing the non-containerized eShopOnWeb monolith from a source Azure VM to Azure Kubernetes Service (AKS).

The source application is Microsoft's public [eShopOnWeb](src/monolith/eShopOnWeb) sample. Initial workshop provisioning creates only the source VM environment and a destination VNet foundation. Attendees choose one or more tracks and create all target AKS and supporting Azure services themselves by using the Azure portal, Azure CLI, or both.

## Provisioning Model

```text
Pre-provisioned by workshop scripts
===================================

Source environment
  Source VNet
  Linux VM running non-containerized eShopOnWeb
  Public HTTP endpoint for baseline validation

Destination environment
  Destination VNet only
  Track-specific subnet layout

Created by attendees during labs
===============================

AKS
Container image and deployment artifacts
Track-specific services such as ACR, APIM, Service Bus, Application Insights, Key Vault, and Defender
```

No ready-made migration scripts, ARM/Bicep templates, or Terraform templates are provided for attendee target setup or migration work. The only automation provided to attendees is initial environment provisioning and cleanup.

## Track Selection

Attendees may choose one track or complete multiple tracks in sequence.

| Track | Target architecture | Services attendees create | Skills and complexity | Expected outcome |
| --- | --- | --- | --- | --- |
| Track A: Simple | Public AKS-hosted eShopOnWeb in the destination VNet. | AKS, container image build/push path of choice, Kubernetes deployment/service/ingress. | Basic AKS and containerization. Lowest complexity. | eShopOnWeb is containerized, deployed to AKS, and reachable through an AKS endpoint. |
| Track B: Enterprise | AKS platform integrated with enterprise routing, registry, messaging, and observability. | AKS, ACR, APIM, Service Bus, Application Insights. | Platform engineering and production patterns. Medium/high complexity. | eShopOnWeb runs on AKS, image flow uses ACR, APIM fronts traffic, Service Bus supports async flow, and telemetry is visible in Application Insights. |
| Track C: Regulated | Private AKS-oriented architecture in a segmented destination VNet with secret governance and security posture controls. | Private AKS, Key Vault, private access components, Defender for Cloud configuration. | Security, private networking, compliance validation. Highest complexity. | eShopOnWeb is migrated to a private AKS posture with Key Vault-backed secret handling and Defender/security validation. |

## Quickstart

Run one command to deploy the source VM, destination VNet foundation, optional VNet peering, validation, and a local foundation report.

Track A foundation:

```powershell
az login
az account set --subscription "<SUBSCRIPTION_ID_OR_NAME>"
./infra/scripts/00-deploy-workshop.ps1 -Track A -Location westeurope -Prefix appmod
```

Track B foundation:

```powershell
az login
az account set --subscription "<SUBSCRIPTION_ID_OR_NAME>"
./infra/scripts/00-deploy-workshop.ps1 -Track B -Location westeurope -Prefix appmod
```

Track C foundation:

```powershell
az login
az account set --subscription "<SUBSCRIPTION_ID_OR_NAME>"
./infra/scripts/00-deploy-workshop.ps1 -Track C -Location westeurope -Prefix appmod
```

The report under `output/` includes the source VM URL, SSH command, resource groups, destination VNet, timings, and deployed foundation artifacts.

## Workshop Docs

### Attendee Docs

1. [Prerequisites](docs-cli/00-prerequisites.md)
2. [Workshop Agenda And Track Selection](docs-cli/01-workshop-agenda.md)
3. [Architecture Overview](docs-cli/02-architecture-overview.md)
4. [Prepare Source And Destination Foundation](docs-cli/03-prepare-source-environment.md)
5. [Track A: Simple AKS Migration](docs-cli/04-track-a-container-apps.md)
6. [Track B: Enterprise AKS Migration](docs-cli/05-track-b-enterprise.md)
7. [Track C: Regulated AKS Migration](docs-cli/06-track-c-regulated.md)
8. [Connect Source And Destination](docs-cli/07-connect-source-destination.md)
9. [Validate Source Baseline](docs-cli/08-validate-source-baseline.md)
10. [Bounded Contexts](docs-cli/09-bounded-contexts.md)
11. [Containerize And Stage Services](docs-cli/10-containerize-and-stage-services.md)
12. [Extract Catalog](docs-cli/11-extract-catalog.md)
13. [Extract Orders And Notifications](docs-cli/12-extract-orders-and-notifications.md)
14. [Data Decomposition](docs-cli/13-data-decomposition.md)
15. [Operational Runbooks](docs-cli/14-operational-runbooks.md)
16. [Troubleshooting](docs-cli/15-troubleshooting.md)
17. [Cost Examples](docs-cli/16-cost-examples.md)

### Facilitator-Only Docs

Facilitator-only material is separated under [docs-facilitator](docs-facilitator/README.md). Do not include these files in attendee handouts.

## Validation Summary

- Track A: source VM works, image is built, AKS deployment is running, and the app is reachable through AKS.
- Track B: Track A validation plus ACR image flow, APIM route, Service Bus integration, and Application Insights telemetry.
- Track C: Track A validation plus private AKS/networking checks, Key Vault secret access, Defender posture checks, and no unintended public access.

## Repository Tree

```text
/
+-- README.md
+-- docs-cli/
+-- docs-facilitator/
+-- docs-portal/
+-- infra/
|   +-- bicep/
|   +-- scripts/
+-- knowledge/
+-- media/
+-- src/
    +-- monolith/eShopOnWeb
    +-- services/
```

## Cleanup

```powershell
./infra/scripts/cleanup.ps1 -ResourceGroupNames rg-appmod-source,rg-appmod-dest-a
```

Use the destination resource group for the track you deployed.

## Disclaimer

This workshop, including all accompanying materials, code samples, scripts, and guidance, is provided for informational and educational purposes only.

Participants are responsible for validating all instructions, configurations, costs, and security settings before use. The materials are simplified for learning and should not be used in production without review and adaptation to organizational policies and best practices.
