# Helm Chart for OSDU on Azure

### Version Tracking

__v1.2.0 -- app-version 0.4.3__
Moved to Isolated Charts

- osdu-azure-base
- osdu-azure-core
- osdu-azure-reference

__v1.1.0 -- app-version 0.4.2__
Adds Unit and CRS Catalog

__v1.0.1 -- app-version 0.4.1__
Adds File and Delivery

__v1.0.0 -- app-version 0.4.0__

Initial Chart supporting R2 Services

### Installation

__Pull Helm Chart__

Helm Charts are stored in OCI format and stored in an Azure Container Registry for Convenience.

```bash
# Setup Variables
CHART=osdu-azure
VERSION=1.2.0

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
DNS_HOST="<your_osdu_fqdn>"         # ie: osdu-$UNIQUE.contoso.com
CERT_EMAIL="<your_admin_email>"     # ie: admin@email.com

# This logs your local Azure CLI in using the configured service principal.
az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID

GROUP=$(az group list --query "[?contains(name, 'cr${UNIQUE}')].name" -otsv)
ENV_VAULT=$(az keyvault list --resource-group $GROUP --query [].name -otsv)

# Translate Values File
cat > osdu_azure_custom_values.yaml << EOF
# This file contains the essential configs for the osdu on azure helm chart

################################################################################
# Specify the default replica count for each service.
#
replicaCount: 2

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
  dns: $DNS_HOST

################################################################################
# Specify the Ingress Settings
#
ingress:
  admin: $CERT_EMAIL
  issuer: letsencrypt-prod-dns
EOF
```


__Helm Chart Intall__

Create a Namespace and install the helm chart for OSDU on Azure.

```bash
# Create Namespace
NAMESPACE=osdu-azure
kubectl create namespace $NAMESPACE && kubectl label namespace $NAMESPACE istio-injection=enabled

# Install Charts
helm install partition-services osdu-azure/osdu-partition_base -n $NAMESPACE -f osdu_azure_custom_values.yaml
helm install security-services osdu-azure/osdu-security_compliance -n $NAMESPACE -f osdu_azure_custom_values.yaml
helm install core-services osdu-azure/osdu-core_services -n $NAMESPACE -f osdu_azure_custom_values.yaml
helm install reference-services osdu-azure/osdu-reference_helper -n $NAMESPACE -f osdu_azure_custom_values.yaml
helm install ingest-services osdu-azure/osdu-ingest_enrich -n $NAMESPACE -f osdu_azure_custom_values.yaml
```
