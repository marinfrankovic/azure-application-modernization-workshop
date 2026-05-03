# 01 - Workshop Agenda

## Objective

Understand the modernization flow and choose one or more VM-to-AKS migration tracks.

## Provisioning Boundary

The workshop scripts provision only the starting foundation:

- Source environment: a VNet and Linux VM running the non-containerized eShopOnWeb monolith from `src/monolith/eShopOnWeb`.
- Destination environment: a VNet with track-appropriate subnets.

Everything else is created by you during the exercises. You may use the Azure portal, Azure CLI, or a combination of both. The attendee labs do not provide ready-made target setup scripts, ARM/Bicep templates, or Terraform templates.

## Track Selection

| Track | Target architecture | Services you create | Skills and complexity | Expected achievement |
| --- | --- | --- | --- | --- |
| Track A: Simple | eShopOnWeb container deployed to AKS in the destination VNet | AKS, container image registry, Kubernetes deployment and service | Basic AKS, containerization, service exposure | Move the monolith from VM hosting to AKS with a minimal platform footprint |
| Track B: Enterprise | AKS-hosted application with registry, gateway, messaging, and observability | AKS, ACR, APIM, Service Bus, Application Insights, Log Analytics | Intermediate platform integration and production patterns | Run eShopOnWeb on AKS and integrate enterprise platform services |
| Track C: Regulated | Private or restricted AKS environment with governed secrets and security posture | Private AKS, Key Vault, Defender for Cloud, private DNS/endpoints as needed | Advanced security, networking, and compliance patterns | Run eShopOnWeb on AKS with regulated access, secrets, and security controls |

You may choose one track for a focused lab or run multiple tracks with different prefixes to compare tradeoffs.

## Flow

1. Complete prerequisites and deploy the workshop foundation.
2. Choose one or more tracks.
3. Review the source VM application and destination VNet.
4. Containerize eShopOnWeb.
5. Create AKS and track-specific services manually.
6. Deploy the application to AKS.
7. Validate workload access, integration, observability, and security requirements for your selected track.
8. Document decisions, rollback, and production hardening.
9. Clean up source and destination resource groups.

## Expected Outcome

You know which track you are following, what the scripts created for you, and what you must create yourself during the modernization exercises.
