# Architecture Notes

The workshop uses a source-to-destination pattern.

## Source

- Deployed by each attendee or team.
- Runs eShopOnWeb as the current monolith.
- Lives in a source VNet.
- Serves as the baseline and rollback anchor.

## Destination

- Created by each attendee or team.
- Lives in a separate destination VNet.
- Hosts decomposed services.
- Varies by selected track.

## Track Selection

- Track A uses Container Apps for simple service hosting.
- Track B uses AKS, APIM, and Service Bus for enterprise architecture.
- Track C adds regulated foundations such as private networking, Key Vault, and Defender.
