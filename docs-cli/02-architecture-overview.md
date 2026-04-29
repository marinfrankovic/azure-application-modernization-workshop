# 02 - Architecture Overview

## Objective

Understand the source and destination topology before changing the application.

## Architecture Explanation

The workshop starts with a source Azure environment that is already running eShopOnWeb. The source VNet represents the current application hosting boundary. Attendees create a separate destination VNet and deploy new platform services there. Decomposition happens by moving selected capabilities from the source monolith into destination services while preserving controlled connectivity.

```text
Prepared source environment
  Source VNet 10.10.0.0/16
    eShopOnWeb monolith

Attendee destination environment
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

1. Record source VNet and source app URL.
2. Choose destination track.
3. Deploy destination VNet and platform.
4. Validate no address space overlap.
5. Add VNet peering only after both environments are known.

## Expected Outcome

You can explain where the monolith runs, where decomposed services run, and how traffic moves between source and destination.
