# Cost Model

Workshop cost is driven by running time.

```text
Cost = hourly service rate x running hours + usage-based charges
```

Use 8 hours as a planning assumption for a full-day lab with setup and cleanup buffer.

## Track Cost Tendency

- Track A is usually lowest cost because Container Apps can scale down.
- Track B costs more because AKS nodes and APIM run for the lab duration.
- Track C cost depends on security services, private networking, and whether workload compute is added.

Always delete resource groups after the workshop.
