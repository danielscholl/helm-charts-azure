# Helm Chart for OSDU Istio on Azure

__Version Tracking__

| Helm Chart Version | istio-base   | istio-operator  |
| ------------------ | ------------ | --------------- |
| `1.1.2`            | `1.1.0`      | `1.7.0`         |
| `1.1.1`            | `1.1.0`      | `1.7.0`         |
| `1.1.0`            | `1.1.0`      | `1.7.0`         |
| `1.0.0`            | `1.1.0`      | `1.7.0`         |


__Pull Helm Chart__

Helm Charts are stored in OCI format and stored in an Azure Container Registry for Convenience.

```bash
# Setup Variables
CHART=osdu-istio
VERSION=1.1.2

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
UNIQUE="<your_osdu_unique>"         # ie: demo

# This logs your local Azure CLI in using the configured service principal.
az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID

GROUP=$(az group list --query "[?contains(name, 'cr${UNIQUE}')].name" -otsv)
ENV_VAULT=$(az keyvault list --resource-group $GROUP --query [].name -otsv)

# Translate Values File
cat > osdu_istio_custom_values.yaml << EOF
# This file contains the essential configs for the osdu on azure helm chart
global:

  ################################################################################
  # Specify the azure environment specific values
  #
  azure:
    tenant: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/tenant-id --query value -otsv)
    appid: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/aad-client-id --query value -otsv)
EOF
```


__Install Helm Chart__

Install the helm chart.

```bash
# Ensure your context is set.
# az aks get-credentials -n <your kubernetes service> --admin -g <resource group>

# Create Namespace
NAMESPACE=istio-system
kubectl create namespace $NAMESPACE

# Install Charts
helm install istio-base osdu-istio/istio-base -n $NAMESPACE
helm install istio-operator osdu-istio/istio-operator \
  --set hub=docker.io/istio \
  --set tag=1.8.2 \
  --set operatorNamespace=istio-operator \
  -n $NAMESPACE

helm install osdu-istio osdu-istio -n $NAMESPACE -f osdu_istio_custom_values.yaml
```
