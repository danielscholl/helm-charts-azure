# Helm Chart for OSDU on Azure Data Initialization Agent

## Helm Chart Values
Either manually modify the values.yaml file or generate a custom_values yaml to use.
_The following commands can help generate a pre-populated custom_values file._
```bash
# Setup Variables
UNIQUE="<your_osdu_unique>"         # e.g. demo
OSDU_HOST="<your_osdu_fqdn>"         # e.g. osdu-$UNIQUE.contoso.com
IMAGE_VERSION="<your-release-version>" # e.g. 0.12.0

# This logs your local Azure CLI in using the configured service principal.
az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID
GROUP=$(az group list --query "[?contains(name, 'cr${UNIQUE}')].name" -otsv)
ENV_VAULT=$(az keyvault list --resource-group $GROUP --query [].name -otsv)

# Translate Values File
cat > ./schema_data_init_custom_values.yaml << EOF
# This file contains the essential configs for the Azure Data Initialization Agent
################################################################################
# Specify the azure environment specific values
#
azure:
  tenant_id: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/tenant-id --query value -otsv)
  resource_id: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/aad-client-id --query value -otsv)
  client_id: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/app-dev-sp-username --query value -otsv)
  client_secret: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/app-dev-sp-password --query value -otsv)

ingress:
  dns: $OSDU_HOST

image:
  repository: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/container-registry --query value -otsv).azurecr.io
  tag: ${IMAGE_VERSION}
EOF
```

__Helm Chart Install__

Create a Namespace and install the helm chart for OSDU on Azure.

```bash
# Create Namespace
NAMESPACE=data-initialization
kubectl create namespace $NAMESPACE

# Install Charts

# Make sure current location is /helm-charts-azure/osdu-azure/osdu-data-initialization/schema-data-initialization

helm install schema-data-init . -n $NAMESPACE -f ./schema_data_init_custom_values.yaml
```