# Helm Chart for OSDU on Azure Airflow

__Version Tracking__

| Helm Chart Version | airflow     | statsd  |
| ------------------ | ----------- |-------- |
| `1.0.x`            | `8.5.2`     | `1.0.0` |


__Pull Helm Chart__
helm version used v3.5.2 for validating charts

Helm Charts are stored in OCI format and stored in an Azure Container Registry for Convenience.

```bash
# Setup Variables
CHART=osdu-airflow2
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
AZURE_ACR="msosdu.azurecr.io"             # Use complete ACR url for this Variable, For eg.
AIRFLOW_IMAGE_TAG="v0.20.1"
STATSD_HOST="appinsights-statsd"
STATSD_PORT="8125"

# This logs your local Azure CLI in using the configured service principal.
az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID

GROUP=$(az group list --query "[?contains(name, 'cr${UNIQUE}')].name" -otsv)
ENV_VAULT=$(az keyvault list --resource-group $GROUP --query [].name -otsv)

# This needs to be set to where OSDU is installed.
OSDU_NAMESPACE=osdu-azure

# Translate Values File
cat > osdu_airflow2_custom_values.yaml << EOF
###############################################################################
# Specify the azure environment specific values
#
appinsightstatsd:
  aadpodidbinding: "osdu-identity"

#################################################################################
# Specify log analytics configuration
#
logAnalytics:
  isEnabled: "true"
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
  repository: $AZURE_ACR


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
    name: airflow2
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
  version_1_Installed: true
  pgbouncer:
    ## if the pgbouncer Deployment is created
    ##
    enabled: false

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
        cert-manager.io/acme-challenge-type: http01
        cert-manager.io/cluster-issuer: letsencrypt-prod-dns
        # Please uncomment below two lines and comment above line to use your own certificate from keyvault
        #cert-manager.io/cluster-issuer: null
        #appgw.ingress.kubernetes.io/appgw-ssl-certificate: "appgw-ssl-cert"
      path: "/airflow2"
      host: $DNS_HOST
      livenessPath: "/airflow2/health"
      tls:
        enabled: true
        secretName: osdu-certificate
      precedingPaths:
        - path: "/airflow2/*"
          serviceName: airflow2-web
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
    database: airflow2

  ###################################
  # Database - External Redis
  ###################################
  redis:
    enabled: false
  externalRedis:
    host: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/base-name-sr --query value -otsv)-queue.redis.cache.windows.net    #<-- Azure Redis Cache host
    port: 6380
    passwordSecret: "redis"
    passwordSecretKey: "redis-queue-password"
    databaseNumber: 2 #<-- Adding redis database number according to the Redis config map https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/master/charts/osdu-common/templates/redis-map.yaml#L7

  ###################################
  # Airflow - DAGs Configs
  ###################################
  dags:
    installRequirements: true
    persistence:
      enabled: true
      existingClaim: airflow2dagpvc
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
    # Use replicas when auto scaling is not enabled
    replicas: 6
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
    replicas: 2
    resources:
      requests:
        cpu: "2500m"
        memory: "1Gi"
      limits:
        cpu: "2500m"
        memory: "1Gi"
    podLabels:
      aadpodidbinding: "osdu-identity"
    autoscale:
      enabled: false
      minReplicas: 2
      maxReplicas: 20
      scaleDown:
        coolDownPeriod: 60
    podAnnotations:
      sidecar.istio.io/inject: "false"
    variables: |
      {}

  ###################################
  # Airflow - Common Configs
  ###################################
  airflow:
    usersUpdate: null
    users: null
    image:
      repository: $AZURE_ACR/airflow2-docker-image
      tag: $AIRFLOW_IMAGE_TAG
      pullPolicy: Always
      pullSecret: ""
    config:
      AIRFLOW__SCHEDULER__STATSD_ON: "True"
      AIRFLOW__SCHEDULER__STATSD_HOST: "${STATSD_HOST}"
      AIRFLOW__SCHEDULER__STATSD_PORT: $STATSD_PORT
      AIRFLOW__SCHEDULER__STATSD_PREFIX: "osdu_airflow2"
      AIRFLOW__CORE__DAGS_ARE_PAUSED_AT_CREATION: "False"
      ## Enable for Debug purpose
      AIRFLOW__WEBSERVER__BASE_URL: https://$DNS_HOST/airflow2
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
      AIRFLOW__CORE__PARALLELISM: "2000"
      AIRFLOW__CORE__MAX_ACTIVE_RUNS_PER_DAG: "2000"
      AIRFLOW__CORE__DAG_CONCURRENCY: "2000"
      AIRFLOW__CELERY__WORKER_CONCURRENCY: "20"
      AIRFLOW__CORE__DAG_FILE_PROCESSOR_TIMEOUT: "1500"
      AIRFLOW_VAR_KEYVAULT_URI: https://$ENV_VAULT.vault.azure.net/
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
        value: "$AZURE_ENABLE_MSI"
      - name: AIRFLOW_VAR_DAG_IMAGE_ACR
        value: $AZURE_ACR
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
      - name: AIRFLOW_VAR_ENV_VARS_ENABLED
        value: "true"
      ## End -- Ingest Manifest DAG variables

    extraPipPackages:
      [
        "flask-bcrypt==0.7.1",
        "apache-airflow[statsd,kubernetes,password]==2.1.2",
        "apache-airflow-providers-microsoft-azure==3.1.1",
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
        "tenacity==6.2.0",
        "authlib==0.15.4",
        "plyvel==1.3.0",
        "apache-airflow-providers-cncf-kubernetes==2.0.2"
      ]
    extraVolumeMounts:
      - name: azure-keyvault
        mountPath: "/mnt/azure-keyvault"
        readOnly: true
      - name: dags-data
        mountPath: /opt/airflow/plugins
        subPath: plugins
      - name: remote-log-config
        mountPath: /opt/airflow/config
        readOnly: true
    extraVolumes:
      - name: azure-keyvault
        csi:
          driver: secrets-store.csi.k8s.io
          readOnly: true
          volumeAttributes:
            secretProviderClass: azure-keyvault-airflow
      - name: remote-log-config
        configMap:
          name: airflow-remote-log-config
    dbMigrations:
      podLabels:
        aadpodidbinding: "osdu-identity"

EOF
```


__Install Helm Chart__

Install the helm chart.

```bash
# Ensure your context is set.
# az aks get-credentials -n <your kubernetes service> --admin -g <resource group>

# Create Namespace
NAMESPACE=airflow2
kubectl create namespace $NAMESPACE

# Install Charts
helm install airflow2 osdu-airflow2 -n $NAMESPACE -f osdu_airflow2_custom_values.yaml
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
