# Networking Notes

Source and destination are separate Azure VNets.

## Principles

- Do not overlap address ranges.
- Peer VNets only when a transition lab requires connectivity.
- Treat source-to-destination connectivity as temporary unless production architecture approves it.
- In regulated environments, prefer private endpoints, private DNS, and explicit firewall or NSG rules.

## Default Address Spaces

| Environment | Address space |
| --- | --- |
| Source | `10.10.0.0/16` |
| Track A destination | `10.20.0.0/16` |
| Track B destination | `10.30.0.0/16` |
| Track C destination | `10.40.0.0/16` |
