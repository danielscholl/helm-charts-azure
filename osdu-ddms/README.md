# Helm Chart for OSDU DDMS on Azure
All DDMSs services have been moved to the common K8S architecture and use of common Helm chart (`standad-ddms`).
Individual DDMSs helm charts are **DEPRECATED!** and will be not supported starting from OSDU M12 (`release/0.15`)

![DDMS K8S deployment](docs/ddms_k8s_deployment.jpeg)


## Pulling Helm Chart
Helm Charts are stored in OCI format and stored in an Azure Container Registry for Convenience.
```bash
CHART="..."
VERSION="..."

ACR='msosdu.azurecr.io'
helm repo add $ACR "https://$ACR/helm/v1/repo"

# Pull Chart
helm pull "oci://$ACR/helm/$CHART" --version $VERSION
```

## Deploying Services

```bash
function deploy() {
  local ddms=$1
  local deployment='osdu'
  local base_dir='./osdu-ddms/standard-ddms/'
  local helm_release="$ddms-services"
  local helm_value_file="${base_dir}${ddms}.${deployment}.values.yaml"
  local k8s_namespace="ddms-$ddms"
  
  # Uninstall if Helm release is not-compatible  
  # helm uninstall $helm_release -n $k8s_namespace

  # Create K8S Namespace with configured Istio sidecar ingejction
  kubectl create namespace $k8s_namespace && \
  kubectl label namespace $k8s_namespace istio-injection='enabled'

  helm upgrade -i \
  $helm_release $base_dir \
  -n $k8s_namespace \
  -f $helm_value_file \
  --set azure.tenant=$azure_tenant \
  --set azure.subscription=$azure_subscription \
  --set azure.resourcegroup=$azure_resourcegroup \
  --set azure.identity=$azure_identity \
  --set azure.identity_id=$azure_identity_id \
  --set azure.keyvault.name=$azure_keyvault \
  --set azure.acr=$azure_acr \
  --set ingress.dns=$ingress_dns  
} 

# Ensure your context is set.
az account set --subscription '<AKS Subscription ID>'
az aks get-credentials --resource-group '<AKS Resource Group>' --name '<AKS resource name>'

# This is specific to OSDU instance:
azure_tenant='...'
azure_subscription='...'
azure_resourcegroup='...'
azure_identity='...'
azure_identity_id='...'
azure_keyvault='...'
azure_acr='...'
ingress_dns='...'

# Deploying DDMSs services
deploy "wellbore"
deploy "seismic"
deploy "well-delivery"

```

__File metadata ddms__

__WARN__ This is not uploaded yet in the msft official helm or docker image repo, you need to build the image.

```shell
SFMD_NAMESPACE=ddms-seismic-file-metadata
kubectl create namespace $SFMD_NAMESPACE && kubectl label namespace $SFMD_NAMESPACE istio-injection=enabled
helm install seismic-metadata-services osdu-ddms/osdu-seismic-metadata_dms -n $SFMD_NAMESPACE -f osdu_ddms_custom_values.yaml --set coreServicesNamepsace=$NAMESPACE --set configuration.0.repository=<youracr>
```
