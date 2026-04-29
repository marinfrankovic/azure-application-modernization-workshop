# 05 - Track B: Enterprise AKS, APIM, And Service Bus

## Objective

Deploy an enterprise destination environment for decomposed services.

## Architecture Explanation

Track B is the main production-oriented path. AKS hosts extracted services, ACR stores images, APIM provides controlled routing, and Service Bus decouples order processing from notifications.

## Azure Services Used

- AKS.
- ACR.
- API Management.
- Service Bus queue `notifications`.
- Application Insights.
- Log Analytics.
- Destination VNet.

## Steps

1. Deploy enterprise destination:

```powershell
./infra/scripts/02-deploy-track-b-enterprise.ps1 -DestinationResourceGroupName rg-appmod-dest-b -Location westeurope -Prefix appmodb
```

2. Validate resources:

```powershell
./infra/scripts/validate.ps1 -ResourceGroupName rg-appmod-dest-b
```

3. Deploy APIM if not included in your selected enterprise run:

```powershell
az deployment group create --resource-group rg-appmod-dest-b --template-file infra/bicep/apim.bicep --parameters prefix=appmodb publisherEmail=you@example.com
```

4. Use `scripts/deploy-services.ps1` for AKS service images.
5. Configure APIM routes from `infra/apim/routes.md`.

## Expected Outcome

A destination AKS platform is ready for incremental monolith decomposition.
