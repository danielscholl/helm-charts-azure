# Standard DDMS Helm Chart

| standard-ddms     | app-version  |
| ----------------- | ----------   |
| 1.11.0            | 0.11.0       |

## Specially Defined Variables
There are pre-defined varaibles that are available whithin Helm:
| Variable              | Description                                           |
| --------------------- | ----------------------------------------------------- |
| <azure_tenant>        | Azure Tenant of Compute RG                            |
| <azure_subscription>  | Azure Subscription of Compute RG                      |
| <azure_resourcegroup> | Name of Compute RG                                    |
| <azure_identity>      | Name of MSI that is used by Pods in AKS               |
| <azure_identity_id>   | ID of MSI                                             |
| <azure_keyvault>      | Name of KeyVault in Compute RG with platform secrets  |
| <azure_appid>         | ...                                                   |
| <azure_corsEnabled>   | Cors Enabled Feature flag                             |
| <azure_acr>           | Name of Azure Container Registry with Images to use   |
| <ingress_dns>         | DNS name assosiated with the Instance                 |


## Supported OSDU Services
- [Wellbore Domain Services](https://community.opengroup.org/osdu/platform/domain-data-mgmt-services/wellbore/wellbore-domain-services.git)


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
image_tag='...'

# Create K8S Namespace with configured Istio sidecar ingejction
kubectl create namespace $namespace && \
kubectl label namespace $namespace istio-injection=enabled

# Example of deployment for Wellbore DDMS
helm install $ddms . -n $namespace \
-f 'wellbore.oak.values.yaml' \ # Wellbore Specic Configs
--set azure.tenant=$azure_tenant \
--set azure.subscription=$azure_subscription \
--set azure.resourcegroup=$azure_resourcegroup \
--set azure.identity=$azure_identity \
--set azure.identity_id=$azure_identity_id \
--set azure.keyvault.name=$azure_keyvault \
--set containers.registry=$azure_acr \
--set ingress.dns=$ingress_dns \
--set "configuration[0].container.tag=$image_tag" \
--set "configuration[0].config.KEYVAULT_URL=https://$azure_keyvault.vault.azure.net/"
```
