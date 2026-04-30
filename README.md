# Azure Application Modernization Workshop

A hands-on workshop for decomposing a real Azure-hosted monolith into destination services across separate Azure VNets.

The workshop uses Microsoft's public [eShopOnWeb](src/monolith/eShopOnWeb) sample as the source monolith. The source environment is prepared before attendees start. Attendees validate the running source, create a separate destination environment, connect source and destination where needed, and progressively move capabilities into the destination.

## Workshop Model

```text
Prepared before workshop
========================

Source Azure environment
  Source VNet
  eShopOnWeb monolith
  Baseline application URL

Built by attendee
=================

Destination Azure environment
  Destination VNet
  Extracted services
  Track-specific platform services
```

## Tracks

| Track | Target | Best for | Azure services |
| --- | --- | --- | --- |
| Track A: Simple | Container Apps | Fast learning path and lightweight hosting | Azure Container Apps, VNet, Log Analytics |
| Track B: Enterprise | AKS + APIM + Service Bus | Enterprise platform and production-style decomposition | AKS, ACR, APIM, Service Bus, App Insights, Log Analytics |
| Track C: Regulated | Private networking + Key Vault + Defender | Regulated and security-first environments | Private VNets, Key Vault, private access patterns, Defender guidance |

## Repository Tree

```text
/
+-- README.md
+-- LICENSE
+-- .gitignore
+-- .gitmodules
+-- docs-cli/
+-- docs-portal/
+-- infra/
|   +-- bicep/
|   +-- scripts/
|   +-- aks/
|   +-- apim/
|   +-- servicebus/
+-- knowledge/
+-- media/
+-- src/
  +-- monolith/eShopOnWeb
  +-- services/
```

## Quickstart

### Facilitator: Prepare Source

Run this before attendees start:

```powershell
az login
az account set --subscription "<SUBSCRIPTION_ID_OR_NAME>"
./infra/scripts/00-prepare-source.ps1 -SourceResourceGroupName rg-appmod-source -Location westeurope -Prefix appmodsrc
```

Share these values with attendees:

- Source resource group name.
- Source VNet name.
- Source app URL.
- Azure region.

### Attendee: Choose Destination Track

Track A:

```powershell
./infra/scripts/01-deploy-track-a-simple.ps1 -DestinationResourceGroupName rg-appmod-dest-a -Location westeurope -Prefix appmoda
```

Track B:

```powershell
./infra/scripts/02-deploy-track-b-enterprise.ps1 -DestinationResourceGroupName rg-appmod-dest-b -Location westeurope -Prefix appmodb
```

Track C:

```powershell
$objectId = az ad signed-in-user show --query id -o tsv
./infra/scripts/03-deploy-track-c-regulated.ps1 -DestinationResourceGroupName rg-appmod-dest-c -Location westeurope -Prefix appmodc -AdminObjectId $objectId
```

Validate:

```powershell
./infra/scripts/validate.ps1 -ResourceGroupName <DESTINATION_RESOURCE_GROUP>
```

## Automation Track

1. [Prerequisites](docs-cli/00-prerequisites.md)
2. [Workshop Agenda](docs-cli/01-workshop-agenda.md)
3. [Architecture Overview](docs-cli/02-architecture-overview.md)
4. [Prepare Source Environment](docs-cli/03-prepare-source-environment.md)
5. [Track A: Container Apps](docs-cli/04-track-a-container-apps.md)
6. [Track B: Enterprise](docs-cli/05-track-b-enterprise.md)
7. [Track C: Regulated](docs-cli/06-track-c-regulated.md)
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

## Azure Portal Track

1. [Prerequisites - Portal](docs-portal/00-prerequisites-portal.md)
2. [Workshop Agenda - Portal](docs-portal/01-workshop-agenda-portal.md)
3. [Architecture Overview - Portal](docs-portal/02-architecture-overview-portal.md)
4. [Prepare Source Environment - Portal](docs-portal/03-prepare-source-environment-portal.md)
5. [Track A - Portal](docs-portal/04-track-a-container-apps-portal.md)
6. [Track B - Portal](docs-portal/05-track-b-enterprise-portal.md)
7. [Track C - Portal](docs-portal/06-track-c-regulated-portal.md)
8. [Connect Source And Destination - Portal](docs-portal/07-connect-source-destination-portal.md)
9. [Validate Source Baseline - Portal](docs-portal/08-validate-source-baseline-portal.md)
10. [Bounded Contexts - Portal](docs-portal/09-bounded-contexts-portal.md)
11. [Containerize And Stage Services - Portal](docs-portal/10-containerize-and-stage-services-portal.md)
12. [Extract Catalog - Portal](docs-portal/11-extract-catalog-portal.md)
13. [Extract Orders And Notifications - Portal](docs-portal/12-extract-orders-and-notifications-portal.md)
14. [Data Decomposition - Portal](docs-portal/13-data-decomposition-portal.md)
15. [Operational Runbooks - Portal](docs-portal/14-operational-runbooks-portal.md)
16. [Troubleshooting - Portal](docs-portal/15-troubleshooting-portal.md)
17. [Cost Examples - Portal](docs-portal/16-cost-examples-portal.md)

## Cost Warning

This workshop deploys billable Azure resources. Review [Cost Examples](docs-cli/16-cost-examples.md) before starting. Cost is tied to running time, so delete source and destination resource groups when finished.

## Cleanup

```powershell
./infra/scripts/cleanup.ps1 -ResourceGroupNames rg-appmod-source,rg-appmod-dest-a
```

Use the destination resource group for the track you deployed.

## Disclaimer

This workshop, including all accompanying materials, code samples, scripts, and guidance, is provided for informational and educational purposes only.

The content is offered "as is" without any warranties, express or implied, including but not limited to warranties of performance, merchantability, fitness for a particular purpose, or non-infringement.

Participants are solely responsible for:
- Reviewing, understanding, and validating all instructions, configurations, and code before use
- Assessing the suitability of the provided solutions for their specific environment and requirements
- Implementing appropriate security, compliance, and operational controls
- Managing and monitoring any cloud resources they deploy

Any deployment of resources, execution of scripts, or use of services may result in costs. Participants are fully responsible for all costs incurred within their Azure subscriptions or other environments as a result of following this workshop.

The workshop materials may include simplified or non-production-ready configurations intended to illustrate concepts. They should not be used in production environments without proper review, testing, and adaptation to organizational policies and best practices.

The author(s) of this workshop assume no liability for any direct, indirect, incidental, or consequential damages, including but not limited to loss of data, service disruption, security incidents, or financial costs arising from the use or misuse of the materials.

By using these materials, you acknowledge and accept full responsibility for any outcomes resulting from their use.
``

### Additional Considerations for Regulated Environments

Participants are responsible for ensuring that any use of the materials complies with applicable regulatory, legal, and organizational requirements, including but not limited to data protection, security, and financial regulations (e.g., DORA, NIS2, GDPR).

The workshop does not guarantee compliance with any regulatory framework.
