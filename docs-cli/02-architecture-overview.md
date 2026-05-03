# 02 - Architecture Overview

## Objective

Understand the source and destination topology before changing the application.

## Architecture Explanation

The workshop starts when you deploy a source Azure environment running eShopOnWeb. The source VNet represents the current application hosting boundary. You then deploy a separate destination VNet and new platform services for the selected track. Decomposition happens by moving selected capabilities from the source monolith into destination services while preserving controlled connectivity.

```text
Self-service source environment
  Source VNet 10.10.0.0/16
    eShopOnWeb monolith

Self-service destination environment
  Track A VNet 10.20.0.0/16 -> Container Apps
  Track B VNet 10.30.0.0/16 -> AKS + APIM + Service Bus
  Track C VNet 10.40.0.0/16 -> private foundations + Key Vault + Defender
```

## Azure Services Used

- Source: VNet, Container Apps or equivalent app hosting, Log Analytics.
- Destination Track A: Container Apps, VNet, Log Analytics.
- Destination Track B: AKS, ACR, APIM, Service Bus, Application Insights.
- Destination Track C: private VNet segmentation, Key Vault, ACR private access, Defender guidance.

## Steps

1. Choose a unique prefix and destination track.
2. Deploy source and destination with `00-deploy-workshop.ps1`.
3. Review the generated report for source VNet, source app URL, destination VNet, and access notes.
4. Validate no address space overlap.
5. Confirm VNet peering after both environments are deployed.

## Expected Outcome

You can explain where the monolith runs, where decomposed services run, and how traffic moves between source and destination.
