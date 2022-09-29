#!/bin/bash
# Script to be used to get latest tag for each of the dependencies of group of charts
# DDMS are not included yet in this, due different logic

# This map it is used to get the latest tag from gitlab api.
# Each project does have a project id to be used to get information about the project.
# Id can be found below of the project Name https://stackoverflow.com/questions/39559689/where-do-i-find-the-project-id-for-the-gitlab-api
declare -A community_map=( 
  ["partition"]="221"
  ["schema"]="26"
  ["storage"]="44"
  ["file"]="90"
  ["indexer"]="25"
  ["search"]="19"
  ["register"]="157"
  ["notification"]="143"
  ["indexer-queue"]="73"
  ["dataset"]="118"
  ["entitlements"]="400"
  ["legal"]="74"
  ["policy"]="420"
  ["unit"]="5"
  ["crs-catalog"]="21"
  ["crs-conversion"]="22"
  ["eds-dms"]="1247"
  ["wks"]="191"
  ["workflow"]="146"
)

function _incremental_osdu_azure_app_parse() {
  for ch in osdu-partition_base osdu-core_services osdu-security_compliance osdu-reference_helper osdu-ingest_enrich; do
    echo "[INFO] Parsing appVersion in subgroup $ch"
    for dependency in $( helm dependency list osdu-azure/$ch | egrep -v "NAME|helm-library|osdu-helm-library" | awk '{print $1}' ); do
      if [[ -z ${community_map[$dependency]} ]]; then echo "[ERROR] Dependency $dependency not supported by this script"; continue; fi
      echo "[INFO] Trying to get latest tag from project $dependency => api/v4/projects/${community_map[$dependency]}"
      AZ_VER=$(curl -s https://community.opengroup.org/api/v4/projects/${community_map[$dependency]}/repository/tags | jq -r .[0].name | sed 's/[a-z]//g')
      echo "[INFO] Latest Tag Version: $AZ_VER"
      if [[ -z AZ_VER ]]; then echo "[ERROR] Not able to retrieve tag"; continue; fi
      echo "[WARN] Parsing appVersion for following files > $dependency <"
      find osdu-azure/$dependency -name "Chart.y*" -print \
        -exec sed -i -e "/appVersion/s/\"\?0.*$/${AZ_VER}/"  {} \;
    done
    helm dependency update osdu-azure/${ch}
  done
}
