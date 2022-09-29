# Azure helm charts install

Setup devops Variable Group with latest version of helm charts.

## Script manual install

It is needed to export following env vars and to login in the AKS cluster and wsl and bash4 (not sh).

```shell
az aks get-credentials -g <svr_rg_name> -n <aks_name>
CR_NAME_RG=<central_resource_group>
export ENV_VAULT=$(az keyvault list --resource-group <> --query [].name -otsv)
export DNS_HOST=<dns_host_for_ingress>

# Optional env vars
# export OSDU_NAMESPACE=<by_default osdu-azure>
# export ISTIO_DNS_HOST=<if_istio_enabled>
# export HELM_WAIT=true  ## By default true, we can disable it

source helm-charts-azure/scripts/osdu_helm_functions.bash
_full_osdu_install
```

## Pipeline install

### Prerequisites

* Take a look to the documentation on how to setup properly azure devops configuration [here](hhttps://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/master/docs/service-automation.md).

### Setup ADO Library - `Azure Target Env - <env>`

__IMPORTANT__: Skip if this was already created in automation stage.

```shell
DATA_PARTITION_NAME=opendes
LEGAL_TAG=opendes-public-usa-dataset-7643990
DNS_HOST="<your_ingress_hostname>"  # ie: osdu.contoso.com
ENVIRONMENT_NAME=$UNIQUE
REDIS_PORT="6380"


az pipelines variable-group create \
  --name "Azure Target Env - ${UNIQUE}" \
  --authorize true \
  --variables \
  AZURE_AD_APP_RESOURCE_ID='$(aad-client-id)' \
  AZURE_DEPLOY_SUBSCRIPTION='$(subscription-id)' \
  AZURE_LEGAL_SERVICEBUS='$('${DATA_PARTITION_NAME}'-sb-connection)' \
  AZURE_TENANT_ID='$(tenant-id)' \
  AZURE_TESTER_SERVICEPRINCIPAL_SECRET='$(app-dev-sp-password)' \
  CONTAINER_REGISTRY_NAME='$(container-registry)' \
  DNS_HOST="$DNS_HOST" \
  DOMAIN="contoso.com" \
  ROOT_DATA_GROUP_QUOTA="5000" \
  ELASTIC_ENDPOINT='$('${DATA_PARTITION_NAME}'-elastic-endpoint)' \
  ELASTIC_USERNAME='$('${DATA_PARTITION_NAME}'-elastic-username)' \
  ELASTIC_PASSWORD='$('${DATA_PARTITION_NAME}'-elastic-password)' \
  ENTV2_REDIS_TTL_SECONDS="1" \
  ENVIRONMENT_NAME="$ENVIRONMENT_NAME" \
  IDENTITY_CLIENT_ID='$(identity_id)' \
  INTEGRATION_TESTER='$(app-dev-sp-username)' \
  MY_TENANT="$DATA_PARTITION_NAME" \
  LEGAL_TAG="$LEGAL_TAG" \
  REDIS_PORT="$REDIS_PORT" \
  STORAGE_ACCOUNT='$('${DATA_PARTITION_NAME}'-storage)' \
  STORAGE_ACCOUNT_KEY='$('${DATA_PARTITION_NAME}'-storage-key)' \
  AZURE_EVENT_SUBSCRIBER_SECRET="secret" \
  AZURE_EVENT_SUBSCRIPTION_ID="subscriptionId" \
  AZURE_EVENT_TOPIC_NAME="topic name" \
  AZURE_DNS_NAME="<your_fqdn>" \
  AZURE_MAPPINGS_STORAGE_CONTAINER="osdu-wks-mappings" \
  AZURE_COSMOS_KEY='$(opendes-cosmos-primary-key)' \
  AZURE_COSMOS_URL='$(opendes-cosmos-endpoint)' \
  ENABLE_KEYVAULT_CERT=false \
  ENABLE_ISTIO_mTLS=false \
  ENABLE_ISTIO_KEYVAULT_CERT=false \
  ISTIO_DNS_HOST="$DNS_HOST"
  -ojson

```

### Setup and Configure the ADO Library `Azure Target Env Secrets - demo`

__IMPORTANT__: Skip if this was already created in automation stage.

This variable group is a linked variable group that links to the Environment Key Vault and retrieves secret common settings.

* aad-client-id
* app-dev-sp-id
* app-dev-sp-password
* app-dev-sp-tenant-id
* app-dev-sp-username
* appinsights-key
* base-name-cr
* base-name-sr
* container-registry
* {partition-name}-cosmos-connection
* {partition-name}-cosmos-endpoint
* {partition-name}-cosmos-primary-key
* {partition-name}-elastic-endpoint
* {partition-name}-elastic-password
* {partition-name}-elastic-username
* {partition-name}-storage
* {partition-name}-storage-key
* {partition-name}-sb-connection
* {partition-name}-sb-namespace
* osdu-identity-id
* subscription-id
* tenant-id

### Create helm install pipeline

* You may want to check your variables for the current version of each stage that will be installed.

```shell
az pipelines create \
  --name 'helm-charts-azure-install'  \
  --repository helm-charts-azure  \
  --branch master  \
  --repository-type tfsgit  \
  --yaml-path /scripts/pipelines/pipeline.yml  \
  --skip-first-run true
  -ojson
```

* OSDU_RX approach

```shell
az pipelines create \
  --name 'helm-charts-azure-install'  \
  --repository OSDU_Rx \
  --branch master  \
  --repository-type tfsgit  \
  --yaml-path /pipelines/helm-charts-azure/pipeline.yml  \
  --skip-first-run true \
  -ojson
```
