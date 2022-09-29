#!/bin/bash
# Needed env var: UNIQUE - stands for dev letter
# Pre-req -> az aks get-credentials
# Usage: Option 1: ./osdu_helm_install -i <osdu-base|osdu-istio|osdu-azure|osdu-airflow2|osdu-ddms>
# Usage: Option 2: ./osdu_helm_install  -r <releaseName> -n <namespace> -s <(Optional)subchart> -c <oci://release/> -v <version>
# Optional env vars:
# Check needed env vars if want to customize the script
# HOSDU_*_VERSION
# Still to be supported by script per stage and to be implemented
# az cli is needed
set -e
set -o pipefail

if [[ -z $ENV_VAULT ]]; then
  GROUP=$(az group list --query "[?contains(name, 'cr${UNIQUE}')].name" -otsv)
  az keyvault list --resource-group $GROUP --query [].name -otsv
  export ENV_VAULT=$(az keyvault list --resource-group $GROUP --query [].name -otsv)
fi

while getopts n:c:r:s:v: flag
do
    case "${flag}" in
        i) OSDU_SECTION=${OPTARG};;
        n) NAMESPACE=${OPTARG};;
        c) OCI_REPO=${OPTARG};;
        r) RELEASE_NAME=${OPTARG};;
        s) RELEASE_SUBCHART=${OPTARG};;
        v) OCI_VERSION=${OPTARG};;
        *) Help;;
    esac
done

function Help()
{
  # Display Help
  echo "Syntax: scriptTemplate [-g|h|v|V]"
  echo "options:"
  echo "i     Osdu section to install <osdu-base|osdu-istio|osdu-azure|osdu-airflow2|osdu-ddms>"
  echo "c     Oci Chart to download I.E.: oci://msosdu.azure.io/helm/osdu-azure."
  echo "r     Release Name. I.E.: partition-services"
  echo "s     Subchart to install I.E.: osdu-partition_base"
  echo "n     Namespace (only if -c -r -s are specified)."
  echo "v     Chart Version (only if -c -r -s are specified)."
  echo
  echo "Example: ./osdu_helm_install.bash -r airflow2 -n airflow2 -c oci://msosdu.azurecr.io/helm/osdu-airflow2 -v 1.16.0"
  echo "Example: ./osdu_helm_install.bash -r partition-services -n osdu-azure -c oci://msosdu.azurecr.io/helm/osdu-azure -v 1.16.0 -s osdu-partition_base"
  echo
}

source $( find . -name 'osdu_helm_functions.bash' -type f )
_check_default_values
WORKDIR=$(mktemp -d)
trap " popd && rm -rf $WORKDIR" EXIT
pushd $WORKDIR

#######
## Function to validate which values shall be used
function _detect_values() {
  echo "[INFO] Generating needed values for $OCI_REPO"
  if [[ $OCI_REPO =~ osdu-azure ]] || [[ $OCI_REPO =~ osdu-istio ]]; then
    if [[ $RELEASE_SUBCHART =~ istio-base ]] || [[ $RELEASE_SUBCHART =~ istio-operator ]]; then
      > custom_values.yaml
      return
    fi
    _generate_osdu_azure_values
    cp -v osdu_azure_custom_values.yaml custom_values.yaml
  elif [[ $OCI_REPO =~ standard-ddms ]]; then
    _generate_standard_ddms_values
    cp -v osdu_ddms_custom_values.yaml custom_values.yaml
  elif [[ $OCI_REPO =~ osdu-airflow2 ]]; then
    _generate_airflow2_values
    cp -v osdu_airflow2_custom_values.yaml custom_values.yaml
  else
    echo "[WARN] No function implemented yet for $OCI_REPO"
    > custom_values.yaml
  fi
}

#######
## Function to oci install helm
function _oci_install() {
  if [[ -z $OCI_REPO ]] || [[ -z $OCI_VERSION ]] || [[ -z $NAMESPACE ]] || [[ -z $RELEASE_NAME ]]; then
    echo "[ERROR] Missing parameters for oci installation"
    Help
  fi
  echo "[INFO] Validating remote published version for $OCI_REPO"
  if ! helm show chart $OCI_REPO --version $OCI_VERSION; then exit 1; fi
  if [[ $NAMESPACE == "airflow2" ]]; then
    kubectl create ns airflow || echo "[WARN] Namespace airflow already exists"
  fi
  echo "[INFO] Release subchart: $RELEASE_SUBCHART"
  helm pull $OCI_REPO --version $OCI_VERSION --untar
  kubectl create ns $NAMESPACE || echo "[WARN] Namespace $NAMESPACE already exists"
  if [[ $NAMESPACE != "istio-system" ]] && [[ $NAMESPACE != "default" ]]; then                            
    kubectl label ns $NAMESPACE istio-injection=enabled || echo "[WARN] Namespace $NAMESPACE already labeled"
  fi
  echo "[INFO] Installing through helm"
  if [[ -z $RELEASE_SUBCHART ]]; then
    echo "helm upgrade -i $RELEASE_NAME ${OCI_REPO##*/} -n $NAMESPACE -f ${OCI_REPO##*/}/values.yaml -f custom_values.yaml $EXTRA_HELM_OPT"
    helm upgrade -i $RELEASE_NAME ${OCI_REPO##*/} -n $NAMESPACE -f ${OCI_REPO##*/}/values.yaml -f custom_values.yaml $EXTRA_HELM_OPT
  else
    echo "helm upgrade -i $RELEASE_NAME ./${OCI_REPO##*/}/${RELEASE_SUBCHART} -n $NAMESPACE -f ${OCI_REPO##*/}/values.yaml -f custom_values.yaml $EXTRA_HELM_OPT"
    helm upgrade -i $RELEASE_NAME ./${OCI_REPO##*/}/${RELEASE_SUBCHART} -n $NAMESPACE -f ${OCI_REPO##*/}/${RELEASE_SUBCHART}/values.yaml -f custom_values.yaml $EXTRA_HELM_OPT
  fi
}

if [[ -z $OSDU_SECTION ]]; then 
  echo "[WARN] No osdu_section specified using OCI installation parameters"
  _detect_values
  _oci_install
else
  case $OSDU_SECTION in
    osdu-base)
      _osdu_base_install
      ;;

    osdu-istio)
      _osdu_istio_install
      ;;

    osdu-airflow2)
      _osdu_airflow2_install
      ;;

    osdu-azure)
      _osdu_azure_install
      ;;

    osdu-ddms)
      _osdu_ddmss_install
      ;;

    *)
      echo -n "unknown OSDU_SECTION -s function not implemented <osdu-base|osdu-istio|osdu-azure|osdu-airflow2|osdu-ddms>"
      ;;
  esac
fi
rm -rf $WORKDIR
popd
