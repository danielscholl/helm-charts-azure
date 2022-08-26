# Helm Chart for OSDU Istio on Azure

__Version Tracking__

| Helm Chart Version | istio-base   | istio-operator  |
| ------------------ | ------------ | --------------- |
| `1.1.6`            | `1.2.0`      | `1.8.0`         |
| `1.1.5`            | `1.1.0`      | `1.7.0`         |
| `1.1.4`            | `1.1.0`      | `1.7.0`         |
| `1.1.3`            | `1.1.0`      | `1.7.0`         |
| `1.1.2`            | `1.1.0`      | `1.7.0`         |
| `1.1.1`            | `1.1.0`      | `1.7.0`         |
| `1.1.0`            | `1.1.0`      | `1.7.0`         |
| `1.0.0`            | `1.1.0`      | `1.7.0`         |


__Pull Helm Chart__

Helm Charts are stored in OCI format and stored in an Azure Container Registry for Convenience.

```bash
# Setup Variables
CHART=osdu-istio
VERSION=1.1.6

# Pull Chart
helm pull oci://msosdu.azurecr.io/helm/$CHART --version $VERSION --untar
```

__Create Helm Chart Values__

Either manually modify the values.yaml for the chart or generate a custom_values yaml to use.

_The following commands can help generate a prepopulated custom_values file._
```bash
# Setup Variables
UNIQUE="<your_osdu_unique>"         # ie: demo
OSDU_NAMESPACE=osdu-azure
ISTIO_DNS_HOST=myappgwistio.contoso.com

# This logs your local Azure CLI in using the configured service principal.
az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID

GROUP=$(az group list --query "[?contains(name, 'cr${UNIQUE}')].name" -otsv)
ENV_VAULT=$(az keyvault list --resource-group $GROUP --query [].name -otsv)

# Translate Values File
cat > osdu_istio_custom_values.yaml << EOF
# This file contains the essential configs for the osdu on azure helm chart
global:
  namespace: ${OSDU_NAMESPACE}

    ################################################################################
  # Specify the azure environment specific values
  #
  azure:


  ################################################################################
  # Specify the azure environment specific values
  #
  azure:
    tenant: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/tenant-id --query value -otsv)
    appid: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/aad-client-id --query value -otsv)
    podIdentityAuthEnabled: false
    srResourceGroupName: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/base-name-sr --query value -otsv)-rg
    kvName: ${ENV_VAULT}
    clusterName: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/base-name-sr --query value -otsv)-aks
    appGwName: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/base-name-sr --query value -otsv)-istio-gw
    subscription: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/subscription-id --query value -otsv)
    podIdentity: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/base-name-cr --query value -otsv)-osdu-identity
    commonPodIdentity: <azure_commonPodIdentity>

  ################################################################################
  # Specify the istio specific values
  # based64 encoded username and password
  #
  istio:
    loadBalancerIP: ""
    enableIstioKeyvaultCert: false
    dns_host: ${ISTIO_DNS_HOST}
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
helm upgrade -i istio-base osdu-istio/istio-base -n $NAMESPACE
helm upgrade -i istio-operator -n $NAMESPACE osdu-istio/istio-operator \
  -f osdu-istio/istio-operator/values.yaml

helm upgrade -i osdu-istio osdu-istio -n $NAMESPACE -f osdu-istio/values.yaml -f osdu_istio_custom_values.yaml
```
