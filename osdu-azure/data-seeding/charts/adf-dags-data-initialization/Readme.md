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
DATAFACTORY_NAME=$(az datafactory list --resource-group $GROUP --query [].name -otsv)

# Translate Values File
cat > ./local/osdu_ds-adf-dags-init_custom_values.yaml << EOF
# This file contains the essential configs for the Azure ADF Dags Data Seeding Agent
################################################################################
# Specify the azure environment specific values
#
global:
  azure:
    resourcegroup: $GROUP
    identity_id: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/osdu-identity-id --query value -otsv)
    tenant_id: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/app-dev-sp-tenant-id --query value -otsv)
    enable_msi: $AZURE_ENABLE_MSI
    tenant: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/tenant-id --query value -otsv)
    subscription: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/subscription-id --query value -otsv)

  config:
    backoff_limit: 3

  ingress:
    dns: $OSDU_HOST

  image:
    repository: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/container-registry --query value -otsv).azurecr.io

config:
  configmapname: 
  data_factory_name: $DATAFACTORY_NAME
  airflow_web_url: <airflow_web_url>
EOF
```

__Helm Chart Install__

Create a Namespace and install the helm chart for OSDU on Azure.

```bash
# Create Namespace
NAMESPACE=data-initialization
kubectl create namespace $NAMESPACE

# Install Charts

# Make sure current location is /helm-charts-azure/osdu-azure/data-seeding/charts/ds-adf-dags-init

# Install Charts
helm install adf-dags-init . -n $NAMESPACE -f ./local/osdu_ds-adf-dags-init_custom_values.yaml
```