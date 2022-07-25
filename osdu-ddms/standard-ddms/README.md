# Standard DDMS Helm Chart

## Chart Parameters
There are instance specific parameters within Helm chart:

| Parameter             | Description                                           |
| --------------------- | ----------------------------------------------------- |
| <azure_tenant>        | Azure Tenant of Compute RG                            |
| <azure_subscription>  | Azure Subscription of Compute RG                      |
| <azure_resourcegroup> | Name of Compute RG                                    |
| <azure_identity>      | Name of MSI that is used by Pods in AKS               |
| <azure_identity_id>   | ID of MSI                                             |
| <azure_keyvault>      | Name of KeyVault in Compute RG with platform secrets  |
| <azure_appid>         | ...                                                   |
| <azure_acr>           | Name of Azure Container Registry with Images to use   |
| <ingress_dns>         | DNS name assosiated with the Instance                 |


## Install Process
Following instructiong show general process of using Standard Helm for deployment of particular services.

```bash
ddms='ddms name'
namespace='namespace where it should be deployed'
azure_tenant='...'
azure_subscription='...'
azure_resourcegroup='...'
azure_identity='...'
azure_identity_id='...'
azure_keyvault='...'
azure_acr='...'
ingress_dns='...'

# Create K8S Namespace with configured Istio sidecar ingejction
kubectl create namespace $namespace && \
kubectl label namespace $namespace istio-injection=enabled

# Example of deployment for Wellbore DDMS
helm upgrade -i $ddms . -n $namespace \
-f 'wellbore.osdu.values.yaml' \ # Wellbore Specic Configs
--set azure.tenant=$azure_tenant \
--set azure.subscription=$azure_subscription \
--set azure.resourcegroup=$azure_resourcegroup \
--set azure.identity=$azure_identity \
--set azure.identity_id=$azure_identity_id \
--set azure.keyvault.name=$azure_keyvault \
--set azure.acr=$azure_acr \
--set ingress.dns=$ingress_dns
```
