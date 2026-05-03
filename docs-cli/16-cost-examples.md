# 16 - Cost Examples

## Objective

Estimate workshop cost based on selected track and running time.

## Important Notes

Prices vary by region, SKU, reservations, currency, and date. Use the Azure Pricing Calculator for final estimates. The numbers below are sample planning figures for a short lab and should be treated as approximate.

## Formula

```text
Estimated cost = hourly service rate x number of running hours + usage-based charges
```

Use elapsed running time from resource creation to cleanup. For example, a 6-hour workshop with 1 hour setup buffer and 1 hour cleanup buffer is 8 billable hours.

## Sample 8-Hour Lab Estimate

| Track | Main billable services | Sample estimate for 8 hours |
| --- | --- | --- |
| Track A: Simple | Container Apps, Log Analytics, VNet | EUR 2 - EUR 8 |
| Track B: Enterprise | AKS nodes, ACR, APIM Developer, Service Bus, Log Analytics | EUR 18 - EUR 45 |
| Track C: Regulated | Private networking foundations, Key Vault, private ACR, Defender plans, Log Analytics | EUR 12 - EUR 35 before workload compute |

## Example Calculation: Track B

Assumptions:

- 2 x `Standard_DS2_v2` AKS nodes for 8 hours.
- APIM Developer tier for 8 hours.
- Basic ACR for 8 hours.
- Service Bus Standard for 8 hours.
- Low Log Analytics ingestion.

```text
AKS nodes:        2 x EUR 0.10 x 8 = EUR 1.60
APIM Developer:  1 x EUR 0.07 x 8 = EUR 0.56
ACR Basic:        1 x EUR 0.01 x 8 = EUR 0.08
Service Bus:      small lab usage    = EUR 0.10 - EUR 1.00
Log Analytics:    small ingestion    = EUR 1.00 - EUR 5.00
Operational buffer and regional variance: EUR 15 - EUR 35
```

Workshop planning estimate: EUR 18 - EUR 45 for a short run.

## Cost Controls

1. Use a unique resource group per attendee or team.
2. Stop immediately after cleanup validation.
3. Keep AKS node count low.
4. Avoid leaving APIM Developer tier running overnight.
5. Keep Log Analytics retention at 30 days or less for labs.
6. Delete both source and destination environments when the workshop ends.

## Expected Outcome

You can estimate cost before starting and tie cost directly to running time.
