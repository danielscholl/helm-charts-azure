# Helm Chart for OSDU on Azure Data Initialization Agent

## Helm Chart Values
Either manually modify the values.yaml file or generate a custom_values yaml to use.
_The following commands can help generate a prepopulated custom_values file._
```bash
# Setup Variables
UNIQUE="<your_osdu_unique>"         # ie: demo
OSDU_HOST="<your_osdu_fqdn>"         # ie: osdu-$UNIQUE.contoso.com
AZURE_ENABLE_MSI="true/false"

# This logs your local Azure CLI in using the configured service principal.
az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID

GROUP=$(az group list --query "[?contains(name, 'cr${UNIQUE}')].name" -otsv)
ENV_VAULT=$(az keyvault list --resource-group $GROUP --query [].name -otsv)

# Translate Values File
cat > ./local/dags_data_init_custom_values.yaml << EOF
# This file contains the essential configs for the Azure Data Initialization Agent
################################################################################
# Specify the azure environment specific values
#
azure:
  resourcegroup: $GROUP
  identity_id: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/osdu-identity-id --query value -otsv)
  tenant_id: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/app-dev-sp-tenant-id --query value -otsv)
  client_id: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/app-dev-sp-username --query value -otsv)
  client_secret: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/app-dev-sp-password --query value -otsv)
  app_resource_id: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/aad-client-id --query value -otsv)
  enable_msi: $AZURE_ENABLE_MSI
  

ingress:
  dns: $OSDU_HOST

config:
  configmapname: 

image:
  repository: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/container-registry --query value -otsv).azurecr.io
EOF
```

__Helm Chart Install__

Create a Namespace and install the helm chart for OSDU on Azure.

```bash
# Create Namespace
NAMESPACE=data-initialization
kubectl create namespace $NAMESPACE

# Install Charts

# Make sure current location is /helm-charts-azure/osdu-azure/osdu-data-initialization/dags-data-initialization

helm install dags-data-init . -n $NAMESPACE -f ./local/dags_data_init_custom_values.yaml
```