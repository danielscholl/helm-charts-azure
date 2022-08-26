# Helm Chart for OSDU on Azure Base

__Version Tracking__

| Helm Chart Version |
| ------------------ |
| `1.0.0`            |


__Pull Helm Chart__

Helm Charts are stored in OCI format and stored in an Azure Container Registry for Convenience.

```bash

```

__Create Helm Chart Values__

Either manually modify the values.yaml for the chart or generate a custom_values yaml to use.

_The following commands can help generate a prepopulated custom_values file._
```bash
# Setup Variables
CERT_EMAIL="<your_admin_email>"     # ie: admin@email.com


# Translate Values File
cat > osdu_base_custom_values.yaml << EOF
# This file contains the essential values for the osdu on azure base helm chart

################################################################################
# Specify the Ingress Settings
#
ingress:
  admin: $CERT_EMAIL
EOF
```


__Install Helm Chart__

Install the helm chart.

```bash
# Ensure your context is set.
# az aks get-credentials -n <your kubernetes service> --admin -g <resource group>
# Setup Variables
CHART=osdu-base
VERSION=1.0.0
# Install Common Charts
helm upgrade -i ${CHART} oci://msosdu.azurecr.io/helm/${CHART} --version ${VERSION} -n default -f osdu_base_custom_values.yaml
```
