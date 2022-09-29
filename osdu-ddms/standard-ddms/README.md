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
| <ingress_dns>         | DNS name associated with the Instance                 |


## Install Process
Following instruction show general process of using Standard Helm for deployment of particular services.

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

# Make sure you are on the correct subscription and connected to the right AKS.
az account set --subscription $azure_subscription
az aks get-credentials --resource-group $azure_resourcegroup --name <azure_kubernetese_service>

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

Each service has its own specific value files that can be used for the deployment.

| DDMS                  | Specific Value File to use                            |
| --------------------- | ----------------------------------------------------- |
| Seismic               | `seismic.osdu.values.yaml`                            |
| Wellbore              | `wellbore.osdu.values.yaml`                           |
| Well Delivery         | `well-delivery.osdu.values.yaml`                      |
| Reservoir             | `reservoir.osdu.values.yaml`                          |

The information about how and what to set for each value files are documented inside both `Values.yaml` and all three specific value files above. Make sure to set all the proper values and flags for your deployment.

## Deploying Using Feature Flag

In order to help customizing DDMS for customers a feature flag is added to the standard helm charts. This flag is located in the `Values.yaml` file:

```yaml
enable: true/false
```

If `enable` flag is set to true, Helm Chart release will contain all Kubernetes objects for particular DDMS. If it is set to false, Helm Release should produce an `Empty` release of DDMS.

The mechanism of `enabling` DDMS for the specific customer is following:

- Using Helm CLI get the Values file that was used to Release particular DDMS and run:

```cli
helm get values seismic-services -n ddms-seismic
```

- Update the value for a specific DDMS to `true`
- Do another Helm release using update Values e.g. :

```cli
helm update -i seismic-services -n ddms-seismic -f <Specific_Value_file.yaml>
```

The information about how and what to set for each value files are documented inside both `Values.yaml` and all three specific value files above. Make sure to set all the proper values and flags for your deployment.
