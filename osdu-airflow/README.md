# Helm Chart for OSDU Airflow on Azure


__Version Tracking__

| Helm Chart Version | airflow     | statsd  |
| ------------------ | ----------- |-------- |
| `1.0.0`            | `7.5.0`     | `1.0.0` |



__Pull Helm Chart__

Helm Charts are stored in OCI format and stored in an Azure Container Registry for Convenience.

```bash
# Setup Variables
CHART=osdu-airflow
VERSION=1.0.0

# Pull Chart
helm chart pull msosdu.azurecr.io/helm/$CHART:$VERSION

# Export Chart
helm chart export msosdu.azurecr.io/helm/$CHART:$VERSION
```

__Helm Chart Values__

Either manually modify the values.yaml for the chart or generate a custom_values yaml to use.

_The following commands can help generate a prepopulated custom_values file._
```bash
# Setup Variables
UNIQUE="<your_osdu_unique>"         # ie: demo

# This logs your local Azure CLI in using the configured service principal.
az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID

GROUP=$(az group list --query "[?contains(name, 'cr${UNIQUE}')].name" -otsv)
ENV_VAULT=$(az keyvault list --resource-group $GROUP --query [].name -otsv)

# Translate Values File
cat > osdu_airflow_custom_values.yaml << EOF
# This file contains the essential configs for the osdu on azure helm chart

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

airflow:
  externalDatabase:
    host: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/base-name-sr --query value -otsv)-pg.postgres.database.azure.com
    user:  osdu_admin@$(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/base-name-sr --query value -otsv)-pg
  externalRedis:
    host: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/base-name-sr --query value -otsv)-cache.redis.cache.windows.net
EOF
```


__Helm Chart Intall__

Create a Namespace and install the helm chart for OSDU on Azure.

```bash
# Create Namespace
NAMESPACE=airflow
kubectl create namespace $NAMESPACE

# Install Charts
helm install airflow osdu-airflow -n $NAMESPACE -f osdu_airflow_custom_values.yaml
```
