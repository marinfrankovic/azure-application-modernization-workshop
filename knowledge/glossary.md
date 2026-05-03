# Glossary

| Term | Meaning |
| --- | --- |
| Source environment | Pre-provisioned Azure VNet and Linux VM running the non-containerized eShopOnWeb monolith. |
| Destination environment | Pre-provisioned destination VNet where attendees create AKS and track-specific services. |
| Track A | Simple AKS migration with minimal supporting services. |
| Track B | Enterprise AKS migration with ACR, APIM, Service Bus, and Application Insights. |
| Track C | Regulated AKS migration with private networking, Key Vault, and Defender. |
| Decomposition | Moving a capability from the monolith into an independently deployable service. |
| Rollback anchor | The source monolith path kept available while destination services are validated. |
