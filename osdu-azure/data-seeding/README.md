# Helm Chart for OSDU on Azure Data Seeding

## Helm Chart Values
Either manually modify the values.yaml file or generate a custom_values yaml to use.
_The following commands can help generate a pre-populated custom_values file._
```bash
# Setup Variables
UNIQUE="<your_osdu_unique>"         # e.g. demo
OSDU_HOST="<your_osdu_fqdn>"         # e.g. osdu-$UNIQUE.contoso.com
SERVICE_DOMAIN="<your_service_domain>" # e.g. contoso.com
IMAGE_VERSION="<your-release-version>" # e.g. 0.12.0
PARTITIONS="<partition_names_as_comma_separated_values>"  # ie: "opendes" OR "opendes,opendes1"
PARTITIONS_HASHES="<partitions_names_hash_as_comma_seperated_values>" # ie: "ophash" OR "op1hash,op2hash"
NAMESPACE="<your_osdu_services_namespace>" # e.g. osdu-azure

# This logs your local Azure CLI in using the configured service principal.
az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID
GROUP=$(az group list --query "[?contains(name, 'cr${UNIQUE}')].name" -otsv)
ENV_VAULT=$(az keyvault list --resource-group $GROUP --query [].name -otsv)

# Translate Values File
cat > ./data_seeding_custom_values.yaml << EOF
# This section contains the essential configs for the all data seeding charts
################################################################################
#
global:
  azure:
    resourcegroup: $GROUP
    subscription: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/subscription-id --query value -otsv)
    identity_id: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/osdu-identity-id --query value -otsv)
    enable_msi: $AZURE_ENABLE_MSI
    tenant_id: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/tenant-id --query value -otsv)
    resource_id: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/aad-client-id --query value -otsv)
    client_id: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/app-dev-sp-username --query value -otsv)
    client_secret: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/app-dev-sp-password --query value -otsv)
    identity: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/base-name-cr --query value -otsv)-osdu-identity
    keyvault: $ENV_VAULT
    appid: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/app-dev-sp-username --query value -otsv)

  storage:
    partitions: $PARTITIONS
    partitions_hash: $PARTITIONS_HASHES

  ingress:
    dns: $OSDU_HOST

  service:
    domain: $SERVICE_DOMAIN

  image:
    repository: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/container-registry --query value -otsv).azurecr.io

  config:
    backoff_limit: 3


# This section contains configuration for ds-schema-init chart
################################################################################
#
ds-schema-init:
  enabled: true

  config:
    configmapname:


# This section contains configuration ds-dags-init chart
################################################################################
#
ds-dags-init:
  enabled: true

  config:
    configmapname:


# This section contains configuration for ds-helper-services chart
################################################################################
#
ds-helper-services:
  enabled: true

  config:
    configmapname:


# This section contains configuration for ds-static-init chart
################################################################################
#
ds-static-init:
  enabled: true

  config:
    configmapname:


# This section contains configuration for ds-instance-init chart
################################################################################
#
ds-instance-init:
  enabled: true

  config:
    configmapname:
EOF
```

__Helm Chart Install__

# Install Charts

# Make sure current location is /helm-charts-azure/osdu-azure

helm install data-seeding .\data-seeding\ -n $NAMESPACE -f ./data_seeding_custom_values.yaml
```