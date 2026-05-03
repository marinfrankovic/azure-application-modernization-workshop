# Facilitator Guide - Track B: Enterprise AKS Complete Solution

## Target State

Track B extends the AKS migration with enterprise platform services. eShopOnWeb runs on AKS, the image is stored in ACR, APIM fronts the workload, Service Bus is available for asynchronous notification integration, and Application Insights or Azure Monitor provides evidence of application activity.

Final resources:

- Source VM still serving eShopOnWeb.
- Destination VNet foundation.
- AKS in the destination VNet.
- ACR with admin user disabled.
- APIM Developer tier routing to the AKS endpoint.
- Service Bus Standard namespace with `notifications` queue.
- Log Analytics and Application Insights.

## Step 1 - Confirm Foundation

CLI:

```powershell
az vm list --resource-group <SOURCE_RG> -d --query "[].{name:name,powerState:powerState,publicIps:publicIps}" -o table
az network vnet show --resource-group <DEST_RG> --name <DEST_VNET> --query "{name:name,addressPrefixes:addressSpace.addressPrefixes,subnets:subnets[].name}" -o json
az aks list --resource-group <DEST_RG> -o table
curl <SOURCE_URL>
```

Expected result: source responds and no AKS cluster exists yet in the destination resource group.

## Step 2 - Set Variables

```powershell
$location = '<LOCATION>'
$destRg = '<DEST_RG>'
$prefix = '<PREFIX>'
$vnetName = '<DEST_VNET>'
$aksName = "$prefix-b-aks"
$acrName = '<UNIQUE_ACR_NAME>'
$lawName = "$prefix-b-law"
$appInsightsName = "$prefix-b-appi"
$serviceBusName = '<UNIQUE_SERVICE_BUS_NAMESPACE>'
$apimName = '<UNIQUE_APIM_NAME>'
$publisherEmail = '<FACILITATOR_OR_ATTENDEE_EMAIL>'
$aksSubnetId = az network vnet subnet show --resource-group $destRg --vnet-name $vnetName --name aks-system --query id -o tsv
```

## Step 3 - Create Observability Foundation

Portal:

1. Create Log Analytics in the destination resource group.
2. Create Application Insights as workspace-based and connect it to Log Analytics.

CLI:

```powershell
az monitor log-analytics workspace create --resource-group $destRg --workspace-name $lawName --location $location
$lawId = az monitor log-analytics workspace show --resource-group $destRg --workspace-name $lawName --query id -o tsv
az monitor app-insights component create --resource-group $destRg --app $appInsightsName --location $location --workspace $lawId --application-type web
$appInsightsConnectionString = az monitor app-insights component show --resource-group $destRg --app $appInsightsName --query connectionString -o tsv
```

Expected result: workspace and Application Insights component exist. If the app is not instrumented, use Application Insights availability testing and AKS Container Insights as the validation path.

## Step 4 - Create ACR

```powershell
az acr create --resource-group $destRg --name $acrName --sku Basic --admin-enabled false --location $location
$acrLoginServer = az acr show --resource-group $destRg --name $acrName --query loginServer -o tsv
```

Expected result: ACR exists and admin user is disabled.

## Step 5 - Create AKS With Monitoring

```powershell
az aks create `
  --resource-group $destRg `
  --name $aksName `
  --location $location `
  --node-count 2 `
  --node-vm-size Standard_DS2_v2 `
  --enable-managed-identity `
  --network-plugin azure `
  --vnet-subnet-id $aksSubnetId `
  --enable-addons monitoring `
  --workspace-resource-id $lawId `
  --generate-ssh-keys

az aks update --resource-group $destRg --name $aksName --attach-acr $acrName
az aks get-credentials --resource-group $destRg --name $aksName --overwrite-existing
kubectl get nodes
```

Portal notes:

- Select the existing destination VNet and `aks-system` subnet.
- Enable Container Insights if the portal flow offers it.
- Use managed identity.
- Keep node count modest for lab cost.

## Step 6 - Build And Push eShopOnWeb

Use the same containerization approach as Track A, with an enterprise tag.

```powershell
$repoRoot = Resolve-Path .
$eshopRoot = Join-Path $repoRoot 'src/monolith/eShopOnWeb'
$imageTag = "$acrLoginServer/eshoponweb:enterprise"
az acr login --name $acrName
docker build -t $imageTag -f "$eshopRoot/src/Web/Dockerfile" $eshopRoot
docker push $imageTag
```

If the upstream Dockerfile is unavailable, use the facilitator reference Dockerfile from Track A.

## Step 7 - Deploy Workload To AKS

```powershell
@"
apiVersion: apps/v1
kind: Deployment
metadata:
  name: eshoponweb
spec:
  replicas: 2
  selector:
    matchLabels:
      app: eshoponweb
  template:
    metadata:
      labels:
        app: eshoponweb
    spec:
      containers:
        - name: web
          image: $imageTag
          ports:
            - containerPort: 8080
          env:
            - name: ASPNETCORE_URLS
              value: http://+:8080
            - name: APPLICATIONINSIGHTS_CONNECTION_STRING
              value: "$appInsightsConnectionString"
---
apiVersion: v1
kind: Service
metadata:
  name: eshoponweb
spec:
  type: LoadBalancer
  selector:
    app: eshoponweb
  ports:
    - port: 80
      targetPort: 8080
"@ | kubectl apply -f -

kubectl rollout status deployment/eshoponweb
$aksIp = kubectl get service eshoponweb -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
Write-Host "AKS URL: http://$aksIp"
```

Expected result: two pods are running and the service has an external endpoint.

## Step 8 - Create Service Bus

Portal:

1. Create Service Bus namespace, Standard SKU.
2. Create queue `notifications`.
3. Use Azure RBAC for production discussion; connection strings may be used only as a lab simplification if attendees document the tradeoff.

CLI:

```powershell
az servicebus namespace create --resource-group $destRg --name $serviceBusName --location $location --sku Standard
az servicebus queue create --resource-group $destRg --namespace-name $serviceBusName --name notifications
az servicebus queue show --resource-group $destRg --namespace-name $serviceBusName --name notifications --query "{name:name,status:status,deadLetteringOnMessageExpiration:deadLetteringOnMessageExpiration}" -o table
```

Optional send/receive validation with Azure CLI extension support varies by tenant. A portal-safe validation is to open the queue, use Service Bus Explorer, send a small test message, and confirm active message count changes.

Reference message body:

```json
{
  "orderId": "workshop-001",
  "recipient": "customer@example.com",
  "channel": "email",
  "message": "Order accepted"
}
```

## Step 9 - Create APIM And Route To AKS

Portal path:

1. Create API Management Developer SKU in the destination resource group.
2. Create an HTTP API named `eshoponweb`.
3. Set Web service URL to `http://<AKS_SERVICE_IP>`.
4. Add operation `GET /` routed to `/`.
5. Add optional operations for catalog paths after attendees inspect eShopOnWeb routes.
6. Test from the APIM test console.

CLI reference:

```powershell
az apim create `
  --resource-group $destRg `
  --name $apimName `
  --location $location `
  --publisher-email $publisherEmail `
  --publisher-name 'Workshop Team' `
  --sku-name Developer

az apim api create `
  --resource-group $destRg `
  --service-name $apimName `
  --api-id eshoponweb `
  --display-name 'eShopOnWeb' `
  --path eshop `
  --service-url "http://$aksIp" `
  --protocols https

az apim api operation create `
  --resource-group $destRg `
  --service-name $apimName `
  --api-id eshoponweb `
  --operation-id get-root `
  --display-name 'Get root' `
  --method GET `
  --url-template '/'
```

Expected result: APIM can return the AKS-hosted eShopOnWeb root page.

## Step 10 - Validate Observability

Generate traffic:

```powershell
1..10 | ForEach-Object { curl "http://$aksIp" | Out-Null }
kubectl logs deployment/eshoponweb --tail=50
```

Portal validation:

1. Open Application Insights and create an availability test against the APIM gateway URL or AKS endpoint.
2. Open Log Analytics and inspect Container Insights tables if enabled.
3. Open AKS Insights and confirm pod CPU/memory charts populate.

If the application does not emit Application Insights SDK telemetry, count availability test results and Container Insights as acceptable workshop evidence. Note this as an instrumentation follow-up.

## Step 11 - Completion Criteria

- Source VM URL responds.
- AKS is in the destination VNet.
- ACR stores the eShopOnWeb image and admin user is disabled.
- AKS pulls from ACR through managed identity permissions.
- APIM route reaches the AKS endpoint.
- Service Bus `notifications` queue exists and accepts a test message.
- Application Insights or Azure Monitor shows generated traffic evidence.
- Attendee can explain how future catalog or orders extraction would use APIM and Service Bus.

## Step 12 - Common Fixes

| Symptom | Likely Cause | Fix |
| --- | --- | --- |
| AKS cannot pull image | Missing AcrPull or wrong tag. | Re-run `az aks update --attach-acr`; verify `kubectl describe pod`. |
| APIM returns 404 | Operation path mismatch. | Test root first with `GET /`, then add deeper routes. |
| APIM returns 502 | Backend unreachable or wrong protocol. | Test `curl http://$aksIp` and update APIM backend URL. |
| No telemetry in App Insights | App not instrumented or availability test missing. | Use Container Insights and add an availability test. |
| Service Bus send fails | Auth or namespace mismatch. | Use portal Service Bus Explorer and verify namespace/queue names. |

## Step 13 - Cleanup Check

```powershell
az group delete --name <SOURCE_RG> --yes --no-wait
az group delete --name <DEST_RG> --yes --no-wait
```
