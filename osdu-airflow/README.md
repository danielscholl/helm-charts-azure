# Helm Chart for OSDU on Azure Airflow

__Version Tracking__

| Helm Chart Version | airflow     | statsd  |
| ------------------ | ----------- |-------- |
| `1.0.x`            | `7.5.0`     | `1.0.0` |


__Pull Helm Chart__

Helm Charts are stored in OCI format and stored in an Azure Container Registry for Convenience.

```bash
# Setup Variables
CHART=osdu-airflow
VERSION=1.0.5

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
UNIQUE="<your_osdu_unique>"               # ie: demo
DNS_HOST="<your_osdu_fqdn>"   # ie: osdu-$UNIQUE.contoso.com

# This logs your local Azure CLI in using the configured service principal.
az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID

GROUP=$(az group list --query "[?contains(name, 'cr${UNIQUE}')].name" -otsv)
ENV_VAULT=$(az keyvault list --resource-group $GROUP --query [].name -otsv)

# This needs to be set to where OSDU is installed.
OSDU_NAMESPACE=osdu-azure

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

################################################################################
# Specify any optional override values
#
airflowLogin:
  name: admin                 #<-- Default Airflow Web UI username

################################################################################
# Specify the airflow configuration override values
#
airflow:
  ingress:
    enabled: true           #<-- Set this to false to disable Admin UI ingress
    web:
      annotations:
        cert-manager.io/cluster-issuer: letsencrypt-prod-dns
      host: $DNS_HOST
  externalDatabase:
    host: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/base-name-sr --query value -otsv)-pg.postgres.database.azure.com
    user:  osdu_admin@$(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/base-name-sr --query value -otsv)-pg
  externalRedis:
    host: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/base-name-sr --query value -otsv)-cache.redis.cache.windows.net

  # The namespace needs to be set to where Airflow has been installed.
  airflow:
    extraEnv:
      - name: AIRFLOW_VAR_CORE__SERVICE__SCHEMA__URL
        value:  "http://schema.${OSDU_NAMESPACE}.svc.cluster.local/api/schema-service/v1/schema"
      - name: AIRFLOW_VAR_CORE__SERVICE__SEARCH__URL
        value: "http://search.${OSDU_NAMESPACE}.svc.cluster.local/api/search/v2"
      - name: AIRFLOW_VAR_CORE__SERVICE__STORAGE__URL
        value:  "http://storage.${OSDU_NAMESPACE}.svc.cluster.local/api/storage/v2/records"
      - name: AIRFLOW_VAR_CORE__SERVICE__FILE__HOST
        value: "http://file.${OSDU_NAMESPACE}.svc.cluster.local/api/file/v2"
      - name: AIRFLOW_VAR_CORE__SERVICE__WORKFLOW__HOST
        value: "http://workflow.${OSDU_NAMESPACE}.svc.cluster.local/api/workflow"
EOF
```


__Install Helm Chart__

Install the helm chart.

```bash
# Ensure your context is set.
# az aks get-credentials -n <your kubernetes service> --admin -g <resource group>

# Create Namespace
NAMESPACE=airflow
kubectl create namespace $NAMESPACE

# Install Charts
helm install airflow osdu-airflow -n $NAMESPACE -f osdu_airflow_custom_values.yaml
```


> Managing airflow users can be from within the Airflow UI or performed using the airflow command found in the running airflow web container.

  ```bash
  # Add a User
  USER_FIRST=<your_firstname>
  USER_LAST=<your_last>
  EMAIL=<your_email>
  PASSWORD=<your_password>

  airflow create_user \
    --role Admin \
    --username $USER_FIRST \
    --firstname $USER_FIRST \
    --lastname $USER_LAST \
    --email $EMAIL \
    --password $PASSWORD
  ```
