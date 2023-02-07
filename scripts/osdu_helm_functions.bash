#!/bin/bash
# Script to get helm values depending on the stages
# Should be already logged in to the AKS
# Expected env vars:
# ENV_VAULT
# DNS_HOST
# Optional env vars
# OSDU_NAMESPACE
# ISTIO_DNS_HOST
# HELM_WAIT=false
# These can be reused for osdu-istio
# Need to be logged in in the azure subscription: az account set -s <subscription_id>

function _check_default_values() {
  if [[ -z $ENV_VAULT ]]; then echo "[ERROR] Not var (ENV_VAULT) defined"; exit 1; fi
  if [[ -z $DNS_HOST ]]; then echo "[ERROR] Not var (DNS_HOST) defined"; exit 1; fi
  if [[ -z $ISTIO_DNS_HOST ]]; then export ISTIO_DNS_HOST=$DNS_HOST; echo "[WARN] No ISTIO_DNS_HOST env, using default => $DNS_HOST"; fi
  if [[ -z $OSDU_ACR ]]; then export OSDU_ACR=msosdu.azurecr.io; echo "[WARN] No OSDU_ACR env, using default => $OSDU_ACR"; fi
  if [[ -z $OSDU_NAMESPACE ]]; then export OSDU_NAMESPACE=osdu-azure; echo "[WARN] No OSDU_NAMESPACE env, using default => $OSDU_NAMESPACE"; fi
  if [[ -z $HOSDU_BASE_VERSION ]]; then export HOSDU_BASE_VERSION=1.0.0; echo "[WARN] No HOSDU_BASE_VERSION env, using default => $HOSDU_BASE_VERSION"; fi
  if [[ -z $HOSDU_ISTIO_VERSION ]]; then export HOSDU_ISTIO_VERSION=1.1.6; echo "[WARN] No HOSDU_ISTIO_VERSION env, using default => $HOSDU_ISTIO_VERSION"; fi
  if [[ -z $HOSDU_AIRFLOW2_VERSION ]]; then export HOSDU_AIRFLOW2_VERSION=1.19.0; echo "[WARN] No HOSDU_AIRFLOW2_VERSION env, using default => $HOSDU_AIRFLOW2_VERSION"; fi
  if [[ -z $HOSDU_AZURE_VERSION ]]; then export HOSDU_AZURE_VERSION=1.19.0; echo "[WARN] No HOSDU_AZURE_VERSION env, using default => $HOSDU_AZURE_VERSION"; fi
  if [[ -z $HOSDU_DMS_VERSION ]]; then export HOSDU_DMS_VERSION=1.19.0; echo "[WARN] No HOSDU_DMS_VERSION env, using default => $HOSDU_DMS_VERSION"; fi
  if [[ -z $EXTRA_HELM_OPT ]]; then
    echo "[INFO] EXTRA_HELM_OPT not specified by default set --wait --timeout 10m --debug"
    export EXTRA_HELM_OPT="--wait --timeout 10m --debug";
  fi
  echo "[INFO] Logging to AKS"
  AZURE_UNIQUE=$(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/base-name-sr --query value -otsv)
  if ! az aks get-credentials -g ${AZURE_UNIQUE}-rg -n ${AZURE_UNIQUE}-aks; then echo "[WARN] Not being able to login to AKS" ; fi
}

function _generate_osdu_azure_values() {
  if [[ -z $ENV_VAULT ]]; then echo "[ERROR] Not var (ENV_VAULT) defined"; exit 1; fi
  if [[ -z $OSDU_NAMESPACE ]]; then export OSDU_NAMESPACE=osdu-azure; echo "[WARN] No OSDU_NAMESPACE env, using default => $OSDU_NAMESPACE"; fi
  echo "[INFO] Generating values to install osdu-azure helm charts"
  cat > osdu_azure_custom_values.yaml << EOF
# This file contains the essential configs for the osdu on azure helm chart
global:
  namespace: $OSDU_NAMESPACE
  replicaCount: 1
  azure:
    tenant: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/tenant-id --query value -otsv)
    subscription: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/subscription-id --query value -otsv)
    resourcegroup: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/base-name-cr --query value -otsv)-rg
    identity: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/base-name-cr --query value -otsv)-osdu-identity
    identity_id: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/osdu-identity-id --query value -otsv)
    keyvault: $ENV_VAULT
    appid: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/aad-client-id --query value -otsv)
    podIdentityAuthEnabled: false
    oidAuthEnabled: false # set this to true if you want to use oid instead of unique_name and upn
    corsEnabled: false # set this to true if you want to enable CORS.
    suthEnabled: false # set this to true if you want to use SAuth identity envoy
    # Extra values for istio
    clusterName: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/base-name-sr --query value -otsv)-aks
    appGwName: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/base-name-sr --query value -otsv)-istio-gw
    subscription: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/subscription-id --query value -otsv)
    srResourceGroupName: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/base-name-sr --query value -otsv)-rg 
    crResourceGroupName: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/base-name-cr --query value -otsv)-rg

  ingestion:
    airflowVersion2Enabled: true
    osduAirflowURL: http://airflow2-web.airflow2.svc.cluster.local:8080/airflow2
    airflowDbName: airflow2

  ingress:
    issuer: letsencrypt-prod-dns
    dns: $DNS_HOST
    enableKeyvaultCert: false         # <- Set this to true in order to use your own keyvault cert

  istio:
    loadBalancerIP: "$(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/istio-int-load-balancer-ip --query value -otsv)"
    enableIstioKeyvaultCert: false
    dns_host: "${ISTIO_DNS_HOST}"
EOF
  echo "[INFO] Created osdu_azure_custom_values.yaml file"
}

function _generate_airflow2_values() {
  if [[ -z $ENV_VAULT ]]; then echo "[ERROR] Not var (ENV_VAULT) defined"; exit 1; fi
  if [[ -z $OSDU_ACR ]]; then export OSDU_ACR=msosdu.azurecr.io; echo "[WARN] No OSDU_ACR env, using default => $OSDU_ACR"; fi
  echo "[INFO] Generating values to install osdu-airflow2 helm charts"
  cat > osdu_airflow2_custom_values.yaml << EOF
azure:
  tenant: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/tenant-id --query value -otsv)
  subscription: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/subscription-id --query value -otsv)
  resourcegroup: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/base-name-cr --query value -otsv)-rg
  identity: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/base-name-cr --query value -otsv)-osdu-identity
  identity_id: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/osdu-identity-id --query value -otsv)
  keyvault: $ENV_VAULT  
  appid: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/aad-client-id --query value -otsv)
pgbouncer:
  enabled: true
  airflowdb:
    name: airflow2
    host: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/base-name-sr --query value -otsv)-pg.postgres.database.azure.com
    user:  osdu_admin@$(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/base-name-sr --query value -otsv)-pg
keda:
  version_2_enabled: true
airflow:
  web:
    replicas: 1
  scheduler:
    replicas: 1
  workers:
    replicas: 1
  ingress:
    web:
      host: $DNS_HOST
      annotations:
        cert-manager.io/cluster-issuer: letsencrypt-prod-dns
  externalDatabase:
    user:  osdu_admin@$(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/base-name-sr --query value -otsv)-pg
  externalRedis:
    host: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/base-name-sr --query value -otsv)-queue.redis.cache.windows.net
  airflow:
    config:
      AIRFLOW__WEBSERVER__BASE_URL: https://$DNS_HOST/airflow2
      AIRFLOW_VAR_KEYVAULT_URI: https://$ENV_VAULT.vault.azure.net/
      AIRFLOW__SCHEDULER__STATSD_HOST: appinsights-statsd
      AIRFLOW__SCHEDULER__STATSD_PORT: "8125"
    extraEnv:
      - name: CLOUD_PROVIDER
        value: "azure"
      - name: AIRFLOW__CORE__FERNET_KEY
        valueFrom:
          secretKeyRef:
            name: airflow
            key: fernet-key
      - name: AIRFLOW_CONN_AZ_LOG
        valueFrom:
          secretKeyRef:
            name: airflow
            key: remote-log-connection
      - name: AIRFLOW_VAR_AZURE_TENANT_ID
        valueFrom:
          secretKeyRef:
            name: active-directory
            key: tenantid
      - name: AIRFLOW_VAR_AZURE_CLIENT_ID
        valueFrom:
          secretKeyRef:
            name: active-directory
            key: principal-clientid
      - name: AIRFLOW_VAR_AZURE_CLIENT_SECRET
        valueFrom:
          secretKeyRef:
            name: active-directory
            key: principal-clientpassword
      - name: AIRFLOW_VAR_AAD_CLIENT_ID
        valueFrom:
          secretKeyRef:
            name: active-directory
            key: application-appid
      - name: AIRFLOW_VAR_APPINSIGHTS_KEY
        valueFrom:
          secretKeyRef:
            name: central-logging
            key: appinsights
      - name: AIRFLOW_VAR_AZURE_DNS_HOST
        value: $DNS_HOST
      - name: AIRFLOW_VAR_AZURE_ENABLE_MSI
        value: "false"
      - name: AIRFLOW_VAR_DAG_IMAGE_ACR
        value: $OSDU_ACR
      - name: PYTHONPATH
        value: "/opt/celery"
      ## Begin -- Ingest Manifest DAG variables
      - name: AIRFLOW_VAR_ENTITLEMENTS_MODULE_NAME
        value: "entitlements_client"
      - name: AIRFLOW_VAR_CORE__CONFIG__DATALOAD_CONFIG_PATH
        value: "/opt/airflow/dags/configs/dataload.ini"
      - name: AIRFLOW_VAR_CORE__SERVICE__SCHEMA__URL
        value: "http://schema.${OSDU_NAMESPACE}.svc.cluster.local/api/schema-service/v1"
      - name: AIRFLOW_VAR_CORE__SERVICE__SEARCH__URL
        value: "http://search.${OSDU_NAMESPACE}.svc.cluster.local/api/search/v2"
      - name: AIRFLOW_VAR_CORE__SERVICE__STORAGE__URL
        value: "http://storage.${OSDU_NAMESPACE}.svc.cluster.local/api/storage/v2"
      - name: AIRFLOW_VAR_CORE__SERVICE__FILE__HOST
        value: "http://file.${OSDU_NAMESPACE}.svc.cluster.local/api/file"
      - name: AIRFLOW_VAR_CORE__SERVICE__WORKFLOW__HOST
        value: "http://workflow.${OSDU_NAMESPACE}.svc.cluster.local/api/workflow/v1"
      - name: AIRFLOW_VAR_CORE__SERVICE__DATASET__HOST
        value: "http://dataset.${OSDU_NAMESPACE}.svc.cluster.local/api/dataset/v1"
      - name: AIRFLOW_VAR_CORE__SERVICE__SEARCH_WITH_CURSOR__URL
        value: "http://search.${OSDU_NAMESPACE}.svc.cluster.local/api/search/v2/query_with_cursor"
      - name: AIRFLOW_VAR_CORE__SERVICE__PARTITION__URL
        value: "http://partition.${OSDU_NAMESPACE}.svc.cluster.local/api/partition/v1"
      - name: AIRFLOW_VAR_CORE__SERVICE__LEGAL__HOST
        value: "http://legal.${OSDU_NAMESPACE}.svc.cluster.local/api/legal/v1"
      - name: AIRFLOW_VAR_CORE__SERVICE__ENTITLEMENTS__URL
        value: "http://entitlements.${OSDU_NAMESPACE}.svc.cluster.local/api/entitlements/v2"          
      - name: AIRFLOW__API__AUTH_BACKEND
        value: "airflow.api.auth.backend.basic_auth"
      - name: AIRFLOW_VAR_ENV_VARS_ENABLED
        value: "true"
      - name: AIRFLOW_VAR_CORE__INGESTION__BATCH_SAVE_SIZE
        value: "500"
      - name: AIRFLOW_VAR_CORE__INGESTION__BATCH_COUNT
        value: "5"
      - name: AIRFLOW_VAR_CORE__INGESTION__BATCH_SAVE_ENABLED
        value: "true"
EOF

  echo "[INFO] Created osdu_airflow2_custom_values.yaml file"
}

function _generate_standard_ddms_values() {
  cat > osdu_ddms_custom_values.yaml << EOF
azure:
  tenant: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/tenant-id --query value -otsv)
  subscription: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/subscription-id --query value -otsv)
  resourcegroup: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/base-name-cr --query value -otsv)-rg
  identity: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/base-name-cr --query value -otsv)-osdu-identity
  identity_id: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/osdu-identity-id --query value -otsv)
  acr: $OSDU_ACR
  keyvault:
    name: $ENV_VAULT
ingress:
  dns: $DNS_HOST
deployment:
  replicaCount: 1
EOF
  echo "[INFO] Created osdu_ddms_custom_values.yaml file"
}

# Functions to install
# Osdu base
function _osdu_base_install() {
  echo "[INFO] Installing osdu-base -- version: $HOSDU_BASE_VERSION"
  echo "helm upgrade -i osdu-base oci://msosdu.azurecr.io/helm/osdu-base"
  helm upgrade -i osdu-base oci://msosdu.azurecr.io/helm/osdu-base --set global.ingress.admin=admin-test@azureglobal.com \
      --version ${HOSDU_BASE_VERSION} -n default ${EXTRA_HELM_OPT}
}

######################
## Istio resources
function _osdu_istio_install() {
  export NAMESPACE=istio-system
  _generate_osdu_azure_values
  echo "[INFO] Installing osdu-istio in NS: $NAMESPACE -- version: $HOSDU_ISTIO_VERSION"
  kubectl create ns $NAMESPACE || echo "[WARN] Not able to create ns"
  kubectl delete cronjob cert-checker -n $NAMESPACE || echo "[INFO] No job to clean"
  kubectl delete job cert-checker -n $NAMESPACE || echo "[INFO] No job to clean"
  helm pull oci://msosdu.azurecr.io/helm/osdu-istio --version $HOSDU_ISTIO_VERSION --untar || return
  helm upgrade -i istio-base osdu-istio/istio-base -n $NAMESPACE ${EXTRA_HELM_OPT} || return
  helm upgrade -i istio-operator -n $NAMESPACE osdu-istio/istio-operator \
    -f osdu-istio/istio-operator/values.yaml ${EXTRA_HELM_OPT} || return
  helm upgrade -i osdu-istio osdu-istio -n $NAMESPACE -f osdu-istio/values.yaml \
    -f osdu_azure_custom_values.yaml || return
}

  ######################
  ## Airflow resources
function _osdu_airflow2_install() {
  export NAMESPACE=airflow2
  _generate_airflow2_values
  echo "[INFO] Installing osdu-airflow in NS: $NAMESPACE -- version: $HOSDU_AIRFLOW2_VERSION"
  kubectl create ns $NAMESPACE || echo "[WARN] Not able to create ns"
  kubectl create ns airflow || echo "[WARN] Not able to create ns"
  kubectl label ns $NAMESPACE istio-injection=enabled
  helm pull oci://msosdu.azurecr.io/helm/osdu-airflow2 --version $HOSDU_AIRFLOW2_VERSION --untar
  echo "helm upgrade -i airflow2 ./osdu-airflow2/ -n $NAMESPACE -f ./osdu-airflow2/values.yaml -f osdu_airflow2_custom_values.yaml ${EXTRA_HELM_OPT}"
  helm upgrade -i airflow2 ./osdu-airflow2/ -n $NAMESPACE \
    -f ./osdu-airflow2/values.yaml -f osdu_airflow2_custom_values.yaml ${EXTRA_HELM_OPT}
}

######################
## Osdu Azure
## Usage: _osdu_azure_install <release_name> <subchart>
function _osdu_azure_install() {
  export NAMESPACE=osdu-azure
  kubectl create ns $NAMESPACE || echo "[WARN] Not able to create ns"
  kubectl label ns $NAMESPACE istio-injection=enabled
  helm show chart oci://msosdu.azurecr.io/helm/osdu-azure --version $HOSDU_AZURE_VERSION
  helm pull oci://msosdu.azurecr.io/helm/osdu-azure --version $HOSDU_AZURE_VERSION --untar
  _generate_osdu_azure_values
  RELEASE_NAME=$2
  SUBCHART=$3  
  if ! [[ -z $SUBCHART ]]; then
    echo "[INFO] Subchart detected, installing $SUBCHART"
    echo "helm upgrade -i $RELEASE_NAME osdu-azure/$SUBCHART -n $NAMESPACE -f osdu_azure_custom_values.yaml ${EXTRA_HELM_OPT}"
    helm upgrade -i $RELEASE_NAME osdu-azure/$SUBCHART -n $NAMESPACE -f osdu_azure_custom_values.yaml ${EXTRA_HELM_OPT}
    return
  fi
  declare -A osdu_azure_map=( 
    ["partition-services"]="osdu-azure/osdu-partition_base"
    ["security-services"]="osdu-azure/osdu-security_compliance"
    ["core-services"]="osdu-azure/osdu-core_services"
    ["reference-services"]="osdu-azure/osdu-reference_helper"
    ["ingest-services"]="osdu-azure/osdu-ingest_enrich"
  )
  echo "[INFO] Installing $CHART in NS: $NAMESPACE -- version: $VERSION"
  for helm_val in ${!osdu_azure_map[@]}; do
    echo "helm upgrade -i ${helm_val} ${osdu_azure_map[$helm_val]} -n $NAMESPACE -f osdu_azure_custom_values.yaml ${EXTRA_HELM_OPT}"
    helm upgrade -i ${helm_val} ${osdu_azure_map[$helm_val]} -n $NAMESPACE -f osdu_azure_custom_values.yaml ${EXTRA_HELM_OPT}
  done
}

######################
## Osdu DDMS
function _osdu_ddmss_install() {
  echo "[INFO] Installing DDMSs in NS -- version: $VERSION"
  helm show chart "oci://msosdu.azurecr.io/helm/standard-ddms" --version $HOSDU_DMS_VERSION
  helm pull "oci://msosdu.azurecr.io/helm/standard-ddms" --version $HOSDU_DMS_VERSION --untar
  _generate_standard_ddms_values
  for ddms in wellbore seismic well-delivery reservoir; do
    local deployment='osdu'
    local helm_value_file="./standard-ddms/${ddms}.${deployment}.values.yaml"
    local k8s_namespace="ddms-$ddms"
    local helm_release="$ddms-services"
    kubectl create namespace $k8s_namespace && \
    kubectl label namespace $k8s_namespace istio-injection='enabled'
    echo "helm upgrade -i $helm_release ./standard-ddms/ -n $k8s_namespace -f $helm_value_file -f osdu_ddms_custom_values.yaml"
    helm upgrade -i $helm_release ./standard-ddms/ -n $k8s_namespace \
      -f $helm_value_file -f osdu_ddms_custom_values.yaml ${EXTRA_HELM_OPT}
  done
}

# Osdu core services and osdu ddms services
function _full_osdu_install() {
  _check_default_values
  WORKDIR=$(mktemp -d)
  trap " popd && rm -rfv $WORKDIR" EXIT
  pushd $WORKDIR
  _osdu_base_install
  _osdu_istio_install
  _osdu_airflow2_install
  _osdu_azure_install
  _osdu_ddmss_install
  popd
}
