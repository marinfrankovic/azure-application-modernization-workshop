# Azure Preparation Plan

Status: Ready for Validation

## Project

Application Modernization on Azure Workshop

## Goal

Create a teaching repository that starts with a prepared Azure source environment running eShopOnWeb in a source VNet, then guides attendees through building a separate Azure destination VNet and decomposing the monolith into it.

## Architecture

- Self-service source VNet with eShopOnWeb baseline.
- Separate destination VNets for each track.
- Track A: Container Apps simple destination.
- Track B: AKS, ACR, APIM, Service Bus, Application Insights.
- Track C: private networking foundations, Key Vault, Defender guidance.

## Decisions

- Source environment is deployed by each attendee or team.
- Attendees build destination environment and decomposition path.
- Keep docs structure aligned with data-resilience-workshop: docs-cli, docs-portal, infra/scripts, knowledge, and media.
- Use in-memory/simple JSON-compatible data stores in microservices to focus on decomposition concepts.
- Keep Bicep concise and parameterized.
- Do not include real secrets, subscription IDs, tenant IDs, or region-specific hardcoding.
- Provide scripts as deployment examples, not automatic production pipelines.

## Validation

- Run Python compile checks where possible.
- Run Bicep build validation.
- Verify required docs, labs, source folders, scripts, and workflow files exist.
