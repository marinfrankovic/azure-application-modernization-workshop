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
| Track A: Simple | Source VM, AKS nodes, registry, networking | EUR 12 - EUR 30 |
| Track B: Enterprise | Source VM, AKS nodes, ACR, APIM Developer, Service Bus, Application Insights, Log Analytics | EUR 20 - EUR 55 |
| Track C: Regulated | Source VM, private AKS nodes, Key Vault, private networking, Defender plans, Log Analytics | EUR 20 - EUR 65 before private access add-ons |

## Example Calculation: Track B

Assumptions:

- 2 x `Standard_DS2_v2` AKS nodes for 8 hours.
- 1 x small source VM for 8 hours.
- APIM Developer tier for 8 hours.
- Basic ACR for 8 hours.
- Service Bus Standard for 8 hours.
- Low Log Analytics ingestion.

```text
Source VM:        1 x lab VM x 8 hours = EUR 1.00 - EUR 4.00
AKS nodes:        2 x node VM x 8 hours = EUR 2.00 - EUR 12.00
APIM Developer:  1 x instance x 8 hours = EUR 0.50 - EUR 2.00
ACR Basic:        1 x registry x 8 hours = EUR 0.05 - EUR 0.50
Service Bus:      small lab usage        = EUR 0.10 - EUR 1.00
Log Analytics:    small ingestion        = EUR 1.00 - EUR 5.00
Operational buffer and regional variance: EUR 15 - EUR 35
```

Workshop planning estimate: EUR 20 - EUR 55 for a short run.

## Cost Controls

1. Use a unique resource group per attendee or team.
2. Stop immediately after cleanup validation.
3. Keep AKS node count low.
4. Avoid leaving APIM Developer tier running overnight.
5. Keep Log Analytics retention at 30 days or less for labs.
6. Delete both source and destination environments when the workshop ends.

## Expected Outcome

You can estimate cost before starting and tie cost directly to running time.
