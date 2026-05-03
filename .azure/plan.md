# Azure Preparation Plan

Status: Ready for Validation

## Project

Application Modernization on Azure Workshop

## Goal

Create a teaching repository that starts with a prepared Azure source environment running non-containerized eShopOnWeb on a VM, then guides attendees through manually creating AKS and track-specific services in a separate destination VNet.

## Architecture

- Self-service source VNet with a Linux VM running eShopOnWeb.
- Separate destination VNet foundation for each track.
- Track A: simple AKS migration.
- Track B: AKS, ACR, APIM, Service Bus, and Application Insights created by attendees.
- Track C: private or restricted AKS, Key Vault, and Defender configuration created by attendees.

## Decisions

- Source VM and destination VNet foundations are deployed by each attendee or team.
- Attendees build AKS, target services, and migration/decomposition path using the portal, Azure CLI, or both.
- Keep docs structure aligned with data-resilience-workshop: docs-cli, docs-portal, infra/scripts, knowledge, and media.
- Use in-memory/simple JSON-compatible data stores in microservices to focus on decomposition concepts.
- Keep Bicep limited to initial foundation provisioning.
- Do not include real secrets, subscription IDs, tenant IDs, or region-specific hardcoding.
- Do not provide ready-made target setup scripts, ARM/Bicep templates, or Terraform templates to attendees beyond initial foundation provisioning and cleanup.

## Validation

- Run Python compile checks where possible.
- Run Bicep build validation.
- Verify required docs, labs, source folders, scripts, and workflow files exist.
