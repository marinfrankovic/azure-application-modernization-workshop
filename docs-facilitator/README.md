# Facilitator-Only Complete Solution Guide

This folder is for facilitators only. Do not include these files in attendee handouts, attendee repositories, or workshop slides unless the delivery model explicitly changes.

Attendee materials intentionally provide objectives, constraints, and validation criteria. These facilitator guides provide complete target-state solutions so facilitators can unblock participants, validate outcomes, and demonstrate a reference implementation when needed.

## Solution Guides

| Track | Guide | Complete Target State |
| --- | --- | --- |
| Track A: Simple | [track-a-simple.md](track-a-simple.md) | eShopOnWeb containerized and running on AKS in the destination VNet. |
| Track B: Enterprise | [track-b-enterprise.md](track-b-enterprise.md) | Track A plus ACR, APIM, Service Bus, Application Insights, and Log Analytics. |
| Track C: Regulated | [track-c-regulated.md](track-c-regulated.md) | Private or restricted AKS, Key Vault, Defender for Cloud, private access controls, and security evidence. |

## Facilitation Flow Guides

Use these first during delivery. They follow the same mental model as attendee docs: common foundation first, then selected track, then the complete solution guide only when needed.

| Track | Flow Guide | Complete Solution |
| --- | --- | --- |
| Track A: Simple | [track-a-facilitation-flow.md](track-a-facilitation-flow.md) | [track-a-simple.md](track-a-simple.md) |
| Track B: Enterprise | [track-b-facilitation-flow.md](track-b-facilitation-flow.md) | [track-b-enterprise.md](track-b-enterprise.md) |
| Track C: Regulated | [track-c-facilitation-flow.md](track-c-facilitation-flow.md) | [track-c-regulated.md](track-c-regulated.md) |

## How To Use These Guides

1. Ask the attendee to explain their intended architecture first.
2. Use the relevant step to diagnose where they are blocked.
3. Provide the smallest useful hint before showing the full solution.
4. Use the validation sections as objective completion criteria.
5. Avoid copying these complete solutions into attendee-facing labs.

## Common Assumptions

The examples use these placeholders. Replace them with the actual names from the generated deployment report.

| Placeholder | Meaning |
| --- | --- |
| `<LOCATION>` | Azure region, for example `westeurope`. |
| `<PREFIX>` | Short unique workshop prefix, for example `appmod42`. |
| `<SOURCE_RG>` | Source resource group, for example `rg-appmod42-source`. |
| `<DEST_RG>` | Destination resource group for the selected track. |
| `<DEST_VNET>` | Destination VNet created by the foundation script. |
| `<AKS_SUBNET>` | Destination AKS subnet name or resource ID. |
| `<INGRESS_SUBNET>` | Destination ingress subnet name or resource ID. |
| `<SOURCE_URL>` | Source VM eShopOnWeb URL from the deployment report. |

## Reference Completion Evidence

A completed facilitation record should include:

- Screenshot or command output showing the source VM application responding.
- Screenshot or command output showing the destination VNet existed before target services were created.
- AKS node and pod status.
- Workload endpoint and application response.
- Track-specific service evidence such as APIM route, Service Bus message, Application Insights telemetry, Key Vault access, or Defender status.
- Cleanup status for source and destination resource groups.
