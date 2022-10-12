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

### Create helm install pipeline

* You may want to check your variables for the current version of each stage that will be installed.

```shell
export ADO_ORGANIZATION=<organization_name>
export ADO_PROJECT=osdu-mvp
az devops login --organization https://dev.azure.com/$ADO_ORGANIZATION
az devops configure --defaults organization=https://dev.azure.com/$ADO_ORGANIZATION project=$ADO_PROJECT

az pipelines create \
  --name 'helm-charts-azure-install'  \
  --repository helm-charts-azure  \
  --branch master  \
  --repository-type tfsgit  \
  --yaml-path /scripts/pipelines/pipeline.yml  \
  --skip-first-run true \
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
