# Standard DDMS Helm Chart

| standard-ddms     | app-version  |
| ----------------- | ----------   |
| 1.11.0            | 0.11.0       |


<azure_tenant>
<azure_subscription>
<azure_resourcegroup>
<azure_identity>
<azure_identity_id>
<azure_keyvault>
<azure_appid>
<azure_corsEnabled>
<azure_acr>
<ingress_dns>


__Supported OSDU Services__
- [Wellbore Domain Services](https://community.opengroup.org/osdu/platform/domain-data-mgmt-services/wellbore/wellbore-domain-services.git)


## Install Process
Either manually modify the values.yaml for the chart or generate a custom_values yaml to use.

_The following commands can help generate a prepopulated custom_values file._
```bash
# Setup Variables
RAND="<your_random_value>"          # ie: jdfe
DNS_HOST="<your_osdu_fqdn>"         # ie: osdu-self-dpljdfe-4zis-gw.centralus.cloudapp.azure.com

GROUP=$(az group list --query "[?contains(name, 'cpl${RAND}')].name" -otsv)
ENV_VAULT=$(az keyvault list --resource-group $GROUP --query [].name -otsv)

# Translate Values File
cat > custom_values.yaml << EOF
################################################################################
# Specify the azure environment specific values
#
EOF

NAMESPACE=osdu-azure
helm template self-managed-osdu-service . -n $NAMESPACE -f custom_values.yaml
```
