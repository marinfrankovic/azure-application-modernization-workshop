# Facilitator Guide - Track C: Regulated AKS Complete Solution

## Target State

Track C demonstrates a regulated migration posture. eShopOnWeb runs on AKS with private or restricted access, secrets are governed through Key Vault, Defender for Cloud posture is enabled where permissions allow, and facilitators can show evidence that public exposure is controlled.

Final resources:

- Source VM still serving eShopOnWeb as rollback.
- Destination VNet foundation with `aks-private`, `private-endpoints`, and `ingress-private` subnets.
- Private or restricted AKS cluster.
- ACR with admin user disabled and private endpoint where feasible.
- Key Vault with RBAC authorization and restricted network access.
- Defender for Cloud plans for Containers and Key Vault where allowed.
- Workload reachable only through approved access path.

## Step 1 - Confirm Foundation And Access Plan

CLI:

```powershell
az vm list --resource-group <SOURCE_RG> -d --query "[].{name:name,powerState:powerState,publicIps:publicIps}" -o table
az network vnet show --resource-group <DEST_RG> --name <DEST_VNET> --query "{name:name,addressPrefixes:addressSpace.addressPrefixes,subnets:subnets[].name}" -o json
curl <SOURCE_URL>
```

Before creating private AKS, decide how facilitators and attendees will run `kubectl`:

- Option A: `az aks command invoke` for lab validation.
- Option B: a temporary jump host in a peered VNet with private DNS resolution.
- Option C: VPN/ExpressRoute or existing corporate network path.

Do not proceed with a private cluster until one access path is chosen.

## Step 2 - Set Variables

```powershell
$location = '<LOCATION>'
$destRg = '<DEST_RG>'
$prefix = '<PREFIX>'
$vnetName = '<DEST_VNET>'
$aksName = "$prefix-c-aks"
$acrName = '<UNIQUE_ACR_NAME>'
$keyVaultName = '<UNIQUE_KEY_VAULT_NAME>'
$lawName = "$prefix-c-law"
$aksSubnetId = az network vnet subnet show --resource-group $destRg --vnet-name $vnetName --name aks-private --query id -o tsv
$peSubnetId = az network vnet subnet show --resource-group $destRg --vnet-name $vnetName --name private-endpoints --query id -o tsv
$tenantId = az account show --query tenantId -o tsv
$userObjectId = az ad signed-in-user show --query id -o tsv
```

## Step 3 - Create Monitoring Workspace

```powershell
az monitor log-analytics workspace create --resource-group $destRg --workspace-name $lawName --location $location
$lawId = az monitor log-analytics workspace show --resource-group $destRg --workspace-name $lawName --query id -o tsv
```

This workspace supports AKS Container Insights and Defender evidence.

## Step 4 - Create Private AKS

CLI reference:

```powershell
az aks create `
  --resource-group $destRg `
  --name $aksName `
  --location $location `
  --node-count 2 `
  --node-vm-size Standard_DS2_v2 `
  --enable-managed-identity `
  --enable-private-cluster `
  --network-plugin azure `
  --vnet-subnet-id $aksSubnetId `
  --enable-addons monitoring `
  --workspace-resource-id $lawId `
  --generate-ssh-keys
```

Portal path:

1. Create Kubernetes service in the destination resource group.
2. Select private cluster or equivalent restricted control plane option.
3. Select the destination VNet and `aks-private` subnet.
4. Enable managed identity.
5. Enable monitoring to the regulated Log Analytics workspace.
6. Keep node count low for lab cost.

Expected result: private AKS exists. `az aks get-credentials` may not be useful from a machine without private network access.

## Step 5 - Verify Private Cluster Access

Use command invoke if no private workstation is available:

```powershell
az aks command invoke --resource-group $destRg --name $aksName --command "kubectl get nodes"
```

If using a jump host, link the private DNS zone to the VNet that hosts the jump host and then run:

```powershell
az aks get-credentials --resource-group $destRg --name $aksName --overwrite-existing
kubectl get nodes
```

Expected result: nodes are `Ready` from the selected private access path.

## Step 6 - Create ACR With Controlled Access

Practical lab sequence:

1. Create ACR with admin disabled.
2. Build and push the image while public access is still enabled, or from a host with private network access.
3. Add private endpoint and DNS.
4. Disable public access after the image path is validated.

CLI:

```powershell
az acr create --resource-group $destRg --name $acrName --sku Premium --admin-enabled false --location $location
$acrId = az acr show --resource-group $destRg --name $acrName --query id -o tsv
$acrLoginServer = az acr show --resource-group $destRg --name $acrName --query loginServer -o tsv
az aks update --resource-group $destRg --name $aksName --attach-acr $acrName
```

Build and push:

```powershell
$repoRoot = Resolve-Path .
$eshopRoot = Join-Path $repoRoot 'src/monolith/eShopOnWeb'
$imageTag = "$acrLoginServer/eshoponweb:regulated"
az acr login --name $acrName
docker build -t $imageTag -f "$eshopRoot/src/Web/Dockerfile" $eshopRoot
docker push $imageTag
```

Private endpoint and DNS:

```powershell
az network private-dns zone create --resource-group $destRg --name privatelink.azurecr.io
az network private-dns link vnet create --resource-group $destRg --zone-name privatelink.azurecr.io --name acr-dns-link --virtual-network $vnetName --registration-enabled false
az network private-endpoint create `
  --resource-group $destRg `
  --name "$acrName-pe" `
  --location $location `
  --subnet $peSubnetId `
  --private-connection-resource-id $acrId `
  --group-id registry `
  --connection-name "$acrName-pe-connection"
az network private-endpoint dns-zone-group create `
  --resource-group $destRg `
  --endpoint-name "$acrName-pe" `
  --name default `
  --private-dns-zone privatelink.azurecr.io `
  --zone-name privatelink.azurecr.io
az acr update --resource-group $destRg --name $acrName --public-network-enabled false
```

Expected result: AKS can pull from ACR without public registry access. If this fails in a constrained lab subscription, document the temporary public-access exception and leave ACR admin disabled.

## Step 7 - Create Key Vault With RBAC And Private Access

```powershell
az keyvault create `
  --resource-group $destRg `
  --name $keyVaultName `
  --location $location `
  --enable-rbac-authorization true `
  --public-network-access Disabled

$keyVaultId = az keyvault show --resource-group $destRg --name $keyVaultName --query id -o tsv
az role assignment create --assignee $userObjectId --role "Key Vault Secrets Officer" --scope $keyVaultId
az keyvault secret set --vault-name $keyVaultName --name eshop-lab-setting --value regulated-demo
```

If secret creation fails after public access is disabled, use an approved private host or temporarily set trusted network access, then restore the restricted setting.

Private endpoint:

```powershell
az network private-dns zone create --resource-group $destRg --name privatelink.vaultcore.azure.net
az network private-dns link vnet create --resource-group $destRg --zone-name privatelink.vaultcore.azure.net --name kv-dns-link --virtual-network $vnetName --registration-enabled false
az network private-endpoint create `
  --resource-group $destRg `
  --name "$keyVaultName-pe" `
  --location $location `
  --subnet $peSubnetId `
  --private-connection-resource-id $keyVaultId `
  --group-id vault `
  --connection-name "$keyVaultName-pe-connection"
az network private-endpoint dns-zone-group create `
  --resource-group $destRg `
  --endpoint-name "$keyVaultName-pe" `
  --name default `
  --private-dns-zone privatelink.vaultcore.azure.net `
  --zone-name privatelink.vaultcore.azure.net
```

Expected result: Key Vault has RBAC enabled, public network access disabled, and a private endpoint.

## Step 8 - Enable Defender For Cloud Plans

CLI:

```powershell
az security pricing create --name Containers --tier Standard
az security pricing create --name KeyVaults --tier Standard
az security pricing show --name Containers --query "{name:name,pricingTier:pricingTier}" -o table
az security pricing show --name KeyVaults --query "{name:name,pricingTier:pricingTier}" -o table
```

Portal:

1. Open Microsoft Defender for Cloud.
2. Open Environment settings.
3. Select the subscription.
4. Enable Containers and Key Vault plans where permitted.
5. Record any permission or policy limitation.

Expected result: plans are enabled or constraints are documented.

## Step 9 - Deploy eShopOnWeb To Private AKS

For private clusters without direct `kubectl`, use `az aks command invoke` with inline manifest content.

```powershell
$manifest = @"
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
            - name: ESHOP_LAB_SETTING
              value: regulated-demo
---
apiVersion: v1
kind: Service
metadata:
  name: eshoponweb
spec:
  type: ClusterIP
  selector:
    app: eshoponweb
  ports:
    - port: 80
      targetPort: 8080
"@

$manifest | Set-Content -Path .\regulated-eshop.yaml
az aks command invoke --resource-group $destRg --name $aksName --file .\regulated-eshop.yaml --command "kubectl apply -f regulated-eshop.yaml && kubectl rollout status deployment/eshoponweb && kubectl get pods,svc"
Remove-Item .\regulated-eshop.yaml
```

If using a private workstation or jump host:

```powershell
kubectl apply -f regulated-eshop.yaml
kubectl rollout status deployment/eshoponweb
kubectl get pods,svc
```

Expected result: pods run and the service is internal only.

## Step 10 - Validate Private Workload Access

Internal validation with command invoke:

```powershell
az aks command invoke --resource-group $destRg --name $aksName --command "kubectl run curltest --image=curlimages/curl --rm -i --restart=Never -- curl -s http://eshoponweb.default.svc.cluster.local"
```

Network validation:

```powershell
az network public-ip list --resource-group $destRg --query "[].{name:name,ip:ipAddress}" -o table
az aks command invoke --resource-group $destRg --name $aksName --command "kubectl get svc eshoponweb -o wide"
```

Expected result:

- Internal service responds from inside the cluster.
- No public Kubernetes service IP exists for eShopOnWeb.
- Any public endpoint is explicitly approved and documented.

## Step 11 - Validate Key Vault And Identity Posture

Minimum evidence:

```powershell
az keyvault show --resource-group $destRg --name $keyVaultName --query "{name:name,enableRbacAuthorization:properties.enableRbacAuthorization,publicNetworkAccess:properties.publicNetworkAccess}" -o table
az role assignment list --scope $keyVaultId --query "[].{principalName:principalName,role:roleDefinitionName}" -o table
az network private-endpoint list --resource-group $destRg --query "[].{name:name,subnet:subnet.id}" -o table
```

If the workload uses Key Vault CSI Driver or workload identity in an extended delivery, validate:

- Workload identity issuer is enabled on AKS.
- Federated credential exists.
- Pod service account maps to the managed identity.
- Secret is mounted or read without embedding credentials.

## Step 12 - Completion Criteria

- Source VM URL responds.
- Private or restricted AKS exists in the destination VNet.
- Facilitator can run `kubectl` through the approved access path.
- ACR admin user is disabled.
- ACR public access is disabled or a temporary exception is documented.
- Key Vault RBAC is enabled.
- Key Vault public access is disabled or a temporary exception is documented.
- Defender Containers and Key Vault plans are enabled or blocked by documented permissions.
- eShopOnWeb runs on AKS and is reachable only internally or through the approved ingress path.
- No secrets are committed or embedded in Kubernetes manifests.

## Step 13 - Common Fixes

| Symptom | Likely Cause | Fix |
| --- | --- | --- |
| Cannot run `kubectl` | Private cluster has no access path. | Use `az aks command invoke` or establish jump host/VPN path. |
| ACR pull fails after disabling public access | Private endpoint DNS or network path missing. | Validate `privatelink.azurecr.io` zone link and ACR private endpoint. |
| Key Vault secret set fails | Public access disabled before private path is ready. | Use approved private host or temporary controlled exception. |
| Defender command fails | Insufficient permissions or unsupported training subscription. | Capture the error and validate remaining controls. |
| Workload has public IP | Service type is LoadBalancer or ingress is public. | Change to ClusterIP/internal ingress and revalidate. |

## Step 14 - Cleanup Check

```powershell
az group delete --name <SOURCE_RG> --yes --no-wait
az group delete --name <DEST_RG> --yes --no-wait
```

For regulated workshops, collect evidence before cleanup because Defender and private endpoint screenshots are often needed for review.
