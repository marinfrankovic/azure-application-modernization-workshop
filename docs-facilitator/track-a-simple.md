# Facilitator Guide - Track A: Simple AKS Complete Solution

## Target State

Track A proves the core modernization path: the VM-hosted eShopOnWeb monolith is containerized, pushed to a registry, deployed to AKS in the destination VNet, and exposed through a Kubernetes service.

Final resources:

- Pre-provisioned source VM still serving eShopOnWeb.
- Pre-provisioned destination VNet with AKS and ingress subnets.
- AKS cluster created by the attendee.
- Container registry created or selected by the attendee.
- eShopOnWeb container image.
- Kubernetes deployment and LoadBalancer service.

## Step 1 - Confirm Foundation

Portal:

1. Open the source resource group.
2. Confirm the VM, public IP, NIC, NSG, and source VNet exist.
3. Browse the source URL from the deployment report.
4. Open the Track A destination resource group.
5. Confirm it contains the destination VNet and no AKS cluster.

CLI:

```powershell
az group show --name <SOURCE_RG> --query name -o tsv
az group show --name <DEST_RG> --query name -o tsv
az vm list --resource-group <SOURCE_RG> -d --query "[].{name:name,powerState:powerState,publicIps:publicIps}" -o table
az network vnet list --resource-group <DEST_RG> --query "[].{name:name,addressPrefixes:addressSpace.addressPrefixes}" -o table
curl <SOURCE_URL>
```

Expected result: source responds over HTTP and destination contains only the VNet foundation.

## Step 2 - Capture Network Values

CLI:

```powershell
$location = '<LOCATION>'
$destRg = '<DEST_RG>'
$aksName = '<PREFIX>-a-aks'
$acrName = '<UNIQUE_ACR_NAME>'
$vnetName = '<DEST_VNET>'
$aksSubnetId = az network vnet subnet show --resource-group $destRg --vnet-name $vnetName --name aks-system --query id -o tsv
```

Portal alternative:

1. Open the destination VNet.
2. Open Subnets.
3. Confirm `aks-system` exists.
4. Copy the subnet resource ID from JSON view if needed.

## Step 3 - Create Registry

Portal:

1. Create Azure Container Registry in the destination resource group.
2. Select Basic SKU for lab cost control.
3. Keep Admin user disabled.
4. Keep public access enabled for Track A unless the attendee deliberately adds private registry access.

CLI:

```powershell
az acr create --resource-group $destRg --name $acrName --sku Basic --admin-enabled false --location $location
$acrLoginServer = az acr show --resource-group $destRg --name $acrName --query loginServer -o tsv
```

Expected result: ACR exists and has an `azurecr.io` login server.

## Step 4 - Create AKS

Portal:

1. Create Kubernetes service.
2. Select the destination resource group.
3. Name the cluster `$aksName`.
4. Use one node for a short lab, two nodes if capacity allows.
5. On Networking, select Azure CNI overlay or Azure CNI based on tenant defaults.
6. Select the existing destination VNet and `aks-system` subnet.
7. Use managed identity.
8. Disable optional add-ons unless needed for the attendee's design.

CLI:

```powershell
az aks create `
  --resource-group $destRg `
  --name $aksName `
  --location $location `
  --node-count 1 `
  --node-vm-size Standard_DS2_v2 `
  --enable-managed-identity `
  --network-plugin azure `
  --vnet-subnet-id $aksSubnetId `
  --generate-ssh-keys

az aks update --resource-group $destRg --name $aksName --attach-acr $acrName
az aks get-credentials --resource-group $destRg --name $aksName --overwrite-existing
kubectl get nodes
```

Expected result: AKS nodes are `Ready` and the cluster can pull from ACR.

## Step 5 - Build The eShopOnWeb Image

Use this Dockerfile as the facilitator reference if the attendee needs a known-good containerization path. Do not place it in the repo as attendee automation unless the workshop format changes.

```dockerfile
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY . .
RUN dotnet publish src/Web/Web.csproj -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "Web.dll"]
```

Build and push from the repository root:

```powershell
$repoRoot = Resolve-Path .
$eshopRoot = Join-Path $repoRoot 'src/monolith/eShopOnWeb'
$imageTag = "$acrLoginServer/eshoponweb:track-a"
az acr login --name $acrName
docker build -t $imageTag -f "$eshopRoot/src/Web/Dockerfile" $eshopRoot
```

If the upstream Dockerfile is unavailable or fails, create the facilitator reference Dockerfile temporarily outside the repo or in a scratch directory and build with it:

```powershell
docker build -t $imageTag -f .\Dockerfile.facilitator $eshopRoot
docker push $imageTag
```

Expected result: ACR contains `eshoponweb:track-a`.

## Step 6 - Deploy To AKS

Reference manifest:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: eshoponweb
spec:
  replicas: 1
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
          image: <ACR_LOGIN_SERVER>/eshoponweb:track-a
          ports:
            - containerPort: 8080
          env:
            - name: ASPNETCORE_URLS
              value: http://+:8080
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
```

Apply it:

```powershell
@"
apiVersion: apps/v1
kind: Deployment
metadata:
  name: eshoponweb
spec:
  replicas: 1
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
kubectl get pods -l app=eshoponweb
kubectl get service eshoponweb
```

## Step 7 - Validate The Complete Solution

```powershell
$aksIp = kubectl get service eshoponweb -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
Write-Host "AKS URL: http://$aksIp"
curl "http://$aksIp"
kubectl logs deployment/eshoponweb --tail=100
```

Completion criteria:

- Source URL responds.
- AKS node is ready.
- eShopOnWeb pod is running.
- Service has an external IP.
- AKS URL returns the application.
- Attendee can explain the rollback path to the source VM.

## Step 8 - Common Fixes

| Symptom | Likely Cause | Fix |
| --- | --- | --- |
| `ImagePullBackOff` | AKS lacks ACR pull permission or image tag is wrong. | Re-run `az aks update --attach-acr`, verify `$imageTag`. |
| Pod starts then exits | App is binding to the wrong port or missing files. | Check `kubectl logs`; set `ASPNETCORE_URLS=http://+:8080`. |
| Service external IP stays pending | Load balancer cannot allocate public IP. | Check node resource group quotas and events with `kubectl describe service eshoponweb`. |
| Browser shows source but not AKS | DNS/cache confusion or wrong endpoint. | Use the service IP directly first. |

## Step 9 - Cleanup Check

For a full workshop cleanup, delete the source and destination resource groups after evidence is collected:

```powershell
az group delete --name <SOURCE_RG> --yes --no-wait
az group delete --name <DEST_RG> --yes --no-wait
```
