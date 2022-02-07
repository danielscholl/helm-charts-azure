# Helm Chart for OSDU on Azure OSDU Intance Initialization Agent

## Helm Chart Values
Either manually modify the values.yaml file or generate a custom_values yaml to use.
_The following commands can help generate a prepopulated custom_values file._
```bash
# Setup Variables
UNIQUE="<your_osdu_unique>"         # ie: demo
OSDU_HOST="<your_osdu_fqdn>"         # ie: osdu-$UNIQUE.contoso.com
PARTITIONS="<partition_names_as_comma_separated_values>"  # ie: "opendes" OR "opendes,opendes1"
CONFIGMAP="config map name" #ie: name of the config map to write the status to, need not exist

# This logs your local Azure CLI in using the configured service principal.
az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID

SUBSCRIPTION=$(az account show --query ["name"] -otsv)
GROUP=$(az group list --query "[?contains(name, 'cr${UNIQUE}')].name" -otsv)
ENV_VAULT=$(az keyvault list --resource-group $GROUP --query [].name -otsv)

# Translate Values File
cat > ./local/instance_init_custom_values.yaml << EOF
# This file contains the essential configs for the Azure Data Initialization Agent
################################################################################
# Specify the azure environment specific values
#
azure:
  resourcegroup: $GROUP
  subscription: $SUBSCRIPTION
  identity_id: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/osdu-identity-id --query value -otsv)
  appid: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/app-dev-sp-username --query value -otsv)

service:
  domain: contoso.com

ingress:
  dns: $OSDU_HOST

storage:
  partitions: $PARTITIONS

config:
  configmapname: $CONFIGMAP

image:
  repository: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/container-registry --query value -otsv).azurecr.io
EOF
```

__Helm Chart Install__

Create a Namespace and install the helm chart for OSDU on Azure.

```bash
# SET Namespace
NAMESPACE=osdu-azure

# Install Charts
# Make sure current location is /helm-charts-azure/osdu-azure/osdu-instance-initialization
helm upgrade --install instance-init . -n $NAMESPACE --create-namespace --values ./local/instance_init_custom_values.yaml
```