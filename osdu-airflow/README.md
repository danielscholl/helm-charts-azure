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
VERSION=1.0.9

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
DNS_HOST="<your_osdu_fqdn>"               # ie: osdu-$UNIQUE.contoso.com
AZURE_ENABLE_MSI="<true/false>"           # Should be kept as false mainly because for enabling MSI for S2S Authentication some extra pod identity changes are required
ENABLE_KEDA_2_X="<true/false>"            # If KEDA version used is 1.5.0 this should be "false", if KEDA is upgraded to 2.x this should be "true"
ACR_NAME="msosdu"
AIRFLOW_IMAGE_TAG="v0.9"
STATSD_HOST="appinsights-statsd"
STATSD_PORT="8125"

# This logs your local Azure CLI in using the configured service principal.
az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID

GROUP=$(az group list --query "[?contains(name, 'cr${UNIQUE}')].name" -otsv)
ENV_VAULT=$(az keyvault list --resource-group $GROUP --query [].name -otsv)

# This needs to be set to where OSDU is installed.
OSDU_NAMESPACE=osdu-azure

# Translate Values File
cat > osdu_airflow_custom_values.yaml << EOF
# This file contains the essential configs for the osdu airflow on azure helm chart
################################################################################
# Specify appinsight statsd config
#
appinsightstatsd:
  aadpodidbinding: "osdu-identity"
  
#################################################################################
# Specify log analytics configuration
#
logAnalytics:
  workspaceId:
    secretName: "central-logging"
    secretKey: "workspace-id"
  workspaceKey:
    secretName: "central-logging"
    secretKey: "workspace-key"

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
image:
  repository: msosdu.azurecr.io

airflowLogin:
  name: admin                                   #<-- Default Airflow Web UI username

airflowAuthentication:
  username: admin
  keyvaultMountPath: /mnt/azure-keyvault/
  passwordKey: airflow-admin-password

################################################################################
# Specify any custom configs/environment values
#
customConfig:
  rbac:
    createUser: "True"

################################################################################
# Specify pgbouncer configuration
#
pgbouncer:
  enabled: true
  port: 6543
  max_client_connections: 3000
  airflowdb:
    name: airflow
    host: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/base-name-sr --query value -otsv)-pg.postgres.database.azure.com
    port: 5432
    pool_size: 100
    user:  osdu_admin@$(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/base-name-sr --query value -otsv)-pg
    passwordSecret: "postgres"
    passwordSecretKey: "postgres-password"

################################################################################
# Specify KEDA configuration
#
keda:
  version_2_enabled: $ENABLE_KEDA_2_X


################################################################################
# Specify the airflow configuration
#
airflow:

  ##################################
  # Kubernetes Pod Operator config
  ##################################
  kubernetesPodOperator:
    namespace: airflow
  
  serviceAccount:
    name: airflow

  ###################################
  # Kubernetes - Ingress Configs
  ###################################
  ingress:
    enabled: true
    web:
      annotations:
        kubernetes.io/ingress.class: azure/application-gateway
        appgw.ingress.kubernetes.io/request-timeout: "300"
        appgw.ingress.kubernetes.io/connection-draining: "true"
        appgw.ingress.kubernetes.io/connection-draining-timeout: "30"
        cert-manager.io/cluster-issuer: letsencrypt-prod-dns
        # Please uncomment below two lines and comment above line to use your own certificate from keyvault
        #cert-manager.io/cluster-issuer: null
        #appgw.ingress.kubernetes.io/appgw-ssl-certificate: "appgw-ssl-cert"
        cert-manager.io/acme-challenge-type: http01
      path: "/airflow"
      host: $DNS_HOST
      livenessPath: "/airflow/health"
      tls:
        enabled: true
        secretName: osdu-certificate
      precedingPaths:
        - path: "/airflow/*"
          serviceName: airflow-web
          servicePort: 8080

  ###################################
  # Database - External Database
  ###################################
  postgresql:
    enabled: false
  externalDatabase:
    type: postgres
    host:  airflow-pgbouncer                              	     #<-- Azure PostgreSQL Database host or pgbouncer host (if pgbouncer is enabled)
    user:  osdu_admin@$(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/base-name-sr --query value -otsv)-pg                           #<-- Azure PostgreSQL Database username, formatted as {username}@{hostname}
    passwordSecret: "postgres"
    passwordSecretKey: "postgres-password"
    port: 6543
    database: airflow

  ###################################
  # Database - Redis Chart
  ###################################
  redis:
    enabled: false
  externalRedis:
    host: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/base-name-sr --query value -otsv)-queue.redis.cache.windows.net    #<-- Azure Redis Cache host
    port: 6380
    passwordSecret: "redis"
    passwordSecretKey: "redis-queue-password"
    databaseNumber: 1  #<-- Adding redis database number according to the Redis config map https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/master/charts/osdu-common/templates/redis-map.yaml#L7

  ###################################
  # Airflow - DAGs Configs
  ###################################
  dags:
    installRequirements: true
    persistence:
      enabled: true
      existingClaim: airflowdagpvc
      subPath: "dags"

  ###################################
  # Airflow - WebUI Configs
  ###################################
  web:
    replicas: 1
    livenessProbe:
      timeoutSeconds: 60
    resources:
      requests:
        cpu: "1000m"
        memory: "4Gi"
      limits:
        cpu: "1000m"
        memory: "4Gi"
    podLabels:
      aadpodidbinding: "osdu-identity"
    autoscale:
      enabled: false
      minReplicas: 2
      maxReplicas: 20
      scaleDown:
        coolDownPeriod: 60
    labels:
      # DO NOT DELETE THIS LABEL. SET IT TO "false" WHEN AUTOSCALING IS DISABLED, SET IT TO "true" WHEN AUTOSCALING IS ENABLED
      autoscalingEnabled: "false"
    podAnnotations:
      sidecar.istio.io/userVolumeMount: '[{"name": "azure-keyvault", "mountPath": "/mnt/azure-keyvault", "readonly": true}]'
    baseUrl: "http://localhost/airflow"

  ###################################
  # Airflow - Worker Configs
  ###################################
  workers:
    resources:
      requests:
        cpu: "1200m"
        memory: "5Gi"
      limits:
        cpu: "1200m"
        memory: "5Gi"
    podLabels:
      aadpodidbinding: "osdu-identity"
    podAnnotations:
      sidecar.istio.io/inject: "false"
    autoscale:
      enabled: false
      minReplicas: 2
      maxReplicas: 20
      scaleDown:
        coolDownPeriod: 300
    celery:
      gracefullTermination: true
      gracefullTerminationPeriod: 600
    labels:
      # DO NOT DELETE THIS LABEL. SET IT TO "false" WHEN AUTOSCALING IS DISABLED, SET IT TO "true" WHEN AUTOSCALING IS ENABLED
      autoscalingEnabled: "false"

  ###################################
  # Airflow - Flower Configs
  ###################################
  flower:
    enabled: false

  ###################################
  # Airflow - Scheduler Configs
  ###################################
  scheduler:
    resources:
      requests:
        cpu: "3000m"
        memory: "1Gi"
      limits:
        cpu: "3000m"
        memory: "1Gi"
    podLabels:
      aadpodidbinding: "osdu-identity"
    podAnnotations:
      sidecar.istio.io/inject: "false"
    variables: |
      {}

  ###################################
  # Airflow - Common Configs
  ###################################
  airflow:
    image:
      repository: $ACR_NAME.azurecr.io/airflow-docker-image
      tag: $AIRFLOW_IMAGE_TAG
      pullPolicy: IfNotPresent
      pullSecret: ""
    config:
      AIRFLOW__SCHEDULER__STATSD_ON: "True"
      AIRFLOW__SCHEDULER__STATSD_HOST: "${STATSD_HOST}"
      AIRFLOW__SCHEDULER__STATSD_PORT: $STATSD_PORT
      AIRFLOW__SCHEDULER__STATSD_PREFIX: "osdu_airflow"
      AIRFLOW__CORE__DAGS_ARE_PAUSED_AT_CREATION: "False"
      ## Enable for Debug purpose
      AIRFLOW__WEBSERVER__EXPOSE_CONFIG: "False"
      AIRFLOW__WEBSERVER__AUTHENTICATE: "True"
      AIRFLOW__WEBSERVER__AUTH_BACKEND: "airflow.contrib.auth.backends.password_auth"
      AIRFLOW__WEBSERVER__RBAC: "True"
      AIRFLOW__API__AUTH_BACKEND: "airflow.api.auth.backend.default"
      AIRFLOW__CORE__REMOTE_LOGGING: "True"
      AIRFLOW__CORE__REMOTE_LOG_CONN_ID: "az_log"
      AIRFLOW__CORE__REMOTE_BASE_LOG_FOLDER: "wasb-airflowlog"
      AIRFLOW__CORE__LOGGING_CONFIG_CLASS: "log_config.DEFAULT_LOGGING_CONFIG"
      AIRFLOW__CORE__LOG_FILENAME_TEMPLATE: "{{ run_id }}/{{ ti.dag_id }}/{{ ti.task_id }}/{{ ts }}/{% if dag_run.conf is not none and 'correlation_id' in dag_run.conf %}{{ dag_run.conf['correlation_id'] }}{% else %}None{% endif %}/{{ try_number }}.log"
      AIRFLOW__CELERY__SSL_ACTIVE: "True"
      AIRFLOW__WEBSERVER__ENABLE_PROXY_FIX: "True"
      AIRFLOW__CORE__PLUGINS_FOLDER: "/opt/airflow/plugins"
      AIRFLOW__SCHEDULER__DAG_DIR_LIST_INTERVAL: 60
      AIRFLOW__CORE__LOGGING_LEVEL: DEBUG
      AIRFLOW__WEBSERVER__WORKERS: 8
      AIRFLOW__WEBSERVER__WORKER_REFRESH_BATCH_SIZE: 0
      AIRFLOW__CORE__STORE_SERIALIZED_DAGS: True #This flag decides whether to serialise DAGs and persist them in DB
      AIRFLOW__CORE__STORE_DAG_CODE: True #This flag decides whether to persist DAG files code in DB
      AIRFLOW__WEBSERVER__WORKER_CLASS: gevent
      AIRFLOW__CELERY__WORKER_CONCURRENCY: 16 # Do not remove this config as it is used for autoscaling as well
    extraEnv:
    - name: CLOUD_PROVIDER
      value: "azure"
    - name: AIRFLOW_VAR_KEYVAULT_URI
      valueFrom:
        configMapKeyRef:
          name: osdu-svc-config
          key: ENV_KEYVAULT
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
      value: "$AZURE_ENABLE_MSI"
    - name: AIRFLOW_VAR_DAG_IMAGE_ACR
      value: "msosdu.azurecr.io"        
    - name: PYTHONPATH
      value: "/opt/celery"
      # Needed for installing python osdu python sdk. In future this will be changed
    - name: CI_COMMIT_TAG
      value: "v0.12.0"
    - name: BUILD_TAG
      value: "v0.12.0"
    ## Begin -- Ingest Manifest DAG variables
    - name: AIRFLOW_VAR_ENTITLEMENTS_MODULE_NAME
      value: "entitlements_client"
    - name: AIRFLOW_VAR_CORE__CONFIG__DATALOAD_CONFIG_PATH
      value: "/opt/airflow/dags/configs/dataload.ini"
    - name: AIRFLOW_VAR_CORE__SERVICE__SCHEMA__URL
      value: "http://schema.${OSDU_NAMESPACE}.svc.cluster.local/api/schema-service/v1/schema"
    - name: AIRFLOW_VAR_CORE__SERVICE__SEARCH__URL
      value: "http://search.${OSDU_NAMESPACE}.svc.cluster.local/api/search/v2/query"
    - name: AIRFLOW_VAR_CORE__SERVICE__STORAGE__URL
      value: "http://storage.${OSDU_NAMESPACE}.svc.cluster.local/api/storage/v2/records"
    - name: AIRFLOW_VAR_CORE__SERVICE__FILE__HOST
      value: "http://file.${OSDU_NAMESPACE}.svc.cluster.local/api/file/v2"
    - name: AIRFLOW_VAR_CORE__SERVICE__WORKFLOW__HOST
      value: "http://workflow.${OSDU_NAMESPACE}.svc.cluster.local/api/workflow"
    - name: AIRFLOW_VAR_CORE__SERVICE__DATASET__HOST
      value: "http://dataset.${OSDU_NAMESPACE}.svc.cluster.local/api/dataset/v1"
    - name: AIRFLOW_VAR_CORE__SERVICE__SEARCH_WITH_CURSOR__URL
      value: "http://search.${OSDU_NAMESPACE}.svc.cluster.local/api/search/v2/query_with_cursor"
    ## End -- Ingest Manifest DAG variables
    extraConfigmapMounts:
        - name: remote-log-config
          mountPath: /opt/airflow/config
          configMap: airflow-remote-log-config
          readOnly: true
        - name: celery-config
          mountPath: /opt/celery
          configMap: celery-config
          readOnly: true
    extraPipPackages: [
        "flask-bcrypt==0.7.1",
        "apache-airflow[statsd]",
        "apache-airflow[kubernetes]",
        "apache-airflow-backport-providers-microsoft-azure==2021.2.5",
        "dataclasses==0.8",
        "google-cloud-storage",
        "python-keycloak==0.24.0",
        "msal==1.9.0",
        "azure-identity==1.5.0",
        "azure-keyvault-secrets==4.2.0",
        "azure-storage-blob",
        "azure-servicebus==7.0.1",
        "toposort==1.6",
        "strict-rfc3339==0.7",
        "jsonschema==3.2.0",
        "pyyaml==5.4.1",
        "requests==2.25.1",
        "tenacity==8.0.1",
        "https://azglobalosdutestlake.blob.core.windows.net/pythonsdk/osdu_api-0.11.0-e908cdaa.tar.gz",
        "https://azglobalosdutestlake.blob.core.windows.net/pythonsdk/osdu_airflow-0.0.1.dev32+ea39f8bd.tar.gz"
    ]
    extraVolumeMounts:
        - name: azure-keyvault
          mountPath: "/mnt/azure-keyvault"
          readOnly: true
        - name: dags-data
          mountPath: /opt/airflow/plugins
          subPath: plugins
    extraVolumes:
        - name: azure-keyvault
          csi:
            driver: secrets-store.csi.k8s.io
            readOnly: true
            volumeAttributes:
              secretProviderClass: azure-keyvault

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


> Managing airflow users can be from within the Airflow UI or performed using the airflow command found in the running airflow web container. To create user via the Post Install Jobs we can set a flag "customConfig.rbac.createUser" to "True". The created username is admin and the password is picked from the keyvault secrets, make sure the secrets are already there in the keyvault.

> If the flag is set to "False" the createuser will create a default user for airflow experimental api authentication and the user can be created by the following process.

  ```bash
  # Get Airflow web container
  # AIRFLOW_WEB_CONTAINER=$(kubectl get pod -n airflow | grep "web" | cut -f 1 -d " ")
  # Login to airflow web container.
  # kubectl exec --stdin --tty $AIRFLOW_WEB_CONTAINER -n airflow -- /bin/bash

  # Add a User
  USER_FIRST=<your_firstname>               # ie: admin
  USER_LAST=<your_last>                     # ie: admin
  EMAIL=<your_email>                        # ie: admin@email.com
  PASSWORD=<your_password>                  # ie: admin

  airflow create_user \
    --role Admin \
    --username $USER_FIRST \
    --firstname $USER_FIRST \
    --lastname $USER_LAST \
    --email $EMAIL \
    --password $PASSWORD


  ```

__Role based access to Airflow__

Airflow RBAC guide [here](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/master/docs/airflow-rbac-guide.md).
  

