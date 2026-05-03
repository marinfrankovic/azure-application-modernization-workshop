# Architecture Notes

The workshop uses a source-to-destination pattern.

## Source

- Deployed by each attendee or team.
- Runs eShopOnWeb as the current non-containerized monolith on a Linux VM.
- Lives in a source VNet.
- Serves as the baseline and rollback anchor.

## Destination

- Created as a VNet foundation by the workshop script.
- Lives in a separate destination VNet.
- Receives AKS and track-specific services created manually by attendees.
- Starts without AKS, registry, gateway, messaging, monitoring, Key Vault, or Defender resources.

## Track Selection

- Track A uses AKS for a simple VM-to-container migration.
- Track B uses AKS, ACR, APIM, Service Bus, and Application Insights for enterprise architecture.
- Track C uses private or restricted AKS with Key Vault and Defender for regulated architecture.
