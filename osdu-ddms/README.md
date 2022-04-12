# Helm Chart for OSDU DDMS on Azure

| `ddms-*-*`          | app-version  |
| ------------------- | ----------   |
| 1.11.0               | 0.11.0        |
| 1.9.0               | 0.9.0        |


__Pull Helm Chart__

Helm Charts are stored in OCI format and stored in an Azure Container Registry for Convenience.

```bash
# Setup Variables
CHART=osdu-ddms
VERSION=1.11.0

# Pull Chart
helm chart pull msosdu.azurecr.io/helm/$CHART:$VERSION

# Export Chart
helm chart export msosdu.azurecr.io/helm/$CHART:$VERSION
```

__Create Helm Chart Values__

Either manually modify the values.yaml for the chart or generate a custom_values yaml to use.

_The following commands can help generate a prepopulated custom_values file._
```bash
# Setup Variables
UNIQUE="<your_osdu_unique>"         # ie: demo
DNS_HOST="<your_osdu_fqdn>"         # ie: osdu-$UNIQUE.contoso.com

# This logs your local Azure CLI in using the configured service principal.
az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID

GROUP=$(az group list --query "[?contains(name, 'cr${UNIQUE}')].name" -otsv)
ENV_VAULT=$(az keyvault list --resource-group $GROUP --query [].name -otsv)

# Translate Values File
cat > osdu_ddms_custom_values.yaml << EOF
# This file contains the essential configs for the osdu on azure helm chart

################################################################################
# Specify the default replica count for each service.
#
replicaCount: 2

################################################################################
# Specify the azure environment specific values
#
azure:
  tenant: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/tenant-id --query value -otsv)
  subscription: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/subscription-id --query value -otsv)
  resourcegroup: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/base-name-cr --query value -otsv)-rg
  identity: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/base-name-cr --query value -otsv)-osdu-identity
  identity_id: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/osdu-identity-id --query value -otsv)
  keyvault: $ENV_VAULT
  appid: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/aad-client-id --query value -otsv)

################################################################################
# Specify the Ingress Settings
#
ingress:
  issuer: letsencrypt-prod-dns
  dns: $DNS_HOST
  enableKeyvaultCert: false           # <- Set this to true in order to use your own keyvault cert
EOF
```
__Moving Previously Installed Version__

Uninstall previously installed versions

```bash
# Seismic
helm uninstall seismic-store-service

# Seismic File Metadata
helm uninstall seismic-file-metadata


# Wellbore 
helm uninstall os-wellbore-ddms

# Well delivery
helm uninstall os-well-delivery-ddms

```

The folder structure has been updated. Please take the latest pull from gitlab 
Make sure the new folder is present at root: osdu-ddms
The following folder should not be present: osdu-azure > osdu-seismic_dms, osdu-wellbore_dms, or osdu-well-delivery-ddms. If present please delete.

__Install Helm Chart__

Install the helm chart.

```bash
# Ensure your context is set.
# az aks get-credentials -n <your kubernetes service> --admin -g <resource group>

# DDMS Namespace
SDMS_NAMESPACE=ddms-seismic
SFMD_NAMESPACE=ddms-seismic-file-metadata
WDMS_NAMESPACE=ddms-wellbore
WDDMS_NAMESPACE=ddms-well-delivery
NAMESPACE=osdu-azure

kubectl create namespace $SDMS_NAMESPACE && kubectl label namespace $SDMS_NAMESPACE istio-injection=enabled
kubectl create namespace $SFMD_NAMESPACE && kubectl label namespace $SFMD_NAMESPACE istio-injection=enabled
kubectl create namespace $WDMS_NAMESPACE && kubectl label namespace $WDMS_NAMESPACE istio-injection=enabled
kubectl create namespace $WDDMS_NAMESPACE && kubectl label namespace $WDDMS_NAMESPACE istio-injection=enabled

# Install Charts
helm install seismic-services osdu-ddms/osdu-seismic_dms -n $SDMS_NAMESPACE -f osdu_ddms_custom_values.yaml --set coreServicesNamepsace=$NAMESPACE
helm install seismic-metadata-services osdu-ddms/osdu-seismic-metadata_dms -n $SFMD_NAMESPACE -f osdu_ddms_custom_values.yaml --set coreServicesNamepsace=$NAMESPACE
helm install wellbore-services osdu-ddms/osdu-wellbore_dms -n $WDMS_NAMESPACE -f osdu_ddms_custom_values.yaml --set coreServicesNamepsace=$NAMESPACE
helm install well-delivery-services osdu-ddms/osdu-well-delivery_dms -n $WDDMS_NAMESPACE -f osdu_ddms_custom_values.yaml --set coreServicesNamepsace=$NAMESPACE
```
