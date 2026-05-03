# 07 - Connect Source And Destination VNets

## Objective

Create controlled connectivity between your source VNet and your destination VNet.

## Architecture Explanation

Source and destination are intentionally separate VNets. During decomposition, controlled connectivity allows destination services to call source APIs or allows APIM to route to both old and new backends. This is a transition pattern, not a final dependency model. The self-service deployment script creates peering by default; run this lab manually only if you skipped peering or are inspecting the networking steps.

## Azure Services Used

- Azure Virtual Network peering.
- Network Security Groups where added by your environment.
- Private DNS zones for regulated extensions.

## Steps

1. Confirm source and destination address ranges do not overlap.
2. If you did not use the self-service script, run:

```powershell
./infra/scripts/04-peer-source-destination.ps1 -SourceResourceGroupName rg-appmod-source -SourceVnetName appmodsrc-source-vnet -DestinationResourceGroupName rg-appmod-dest-b -DestinationVnetName appmodb-dest-ent-vnet
```

3. Confirm peering state is Connected in both directions.
4. Test name resolution or endpoint reachability according to the selected track.
5. Record any firewall, NSG, or private DNS changes.

## Expected Outcome

The destination environment can reach approved source endpoints for transition scenarios.
