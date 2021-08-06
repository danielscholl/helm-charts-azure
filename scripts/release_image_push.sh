#!/bin/bash

declare -a src_img=("crs-catalog-service" "crs-conversion-service" "entitlements" "file" "indexer-service" "ingestion-workflow" "legal" "notification" "partition" "policy" "register" "schema-service" "search-service" "storage" "unit-service" "wks")

declare -a dest_img=("crs-catalog" "crs-conversion" "entitlements" "file" "indexer" "indexer-queue" "legal" "notification" "partition" "policy" "register" "schema" "search" "storage" "unit" "wks")

declare src_version="-v0.10.0"
declare dest_version="0.10.0"

# get length of an array
len=${#src_img[@]}

for (( i=0; i<${len}; i++ ));
do
  declare pull_cmd="docker pull osdumvpcrglabqh63cr.azurecr.io/release$src_version:${src_img[$i]}$src_version"
  declare tag_cmd="docker tag osdumvpcrglabqh63cr.azurecr.io/release$src_version:${src_img[$i]}$src_version msosdu.azurecr.io/${dest_img[$i]}:$dest_version"
  declare push_cmd="docker push msosdu.azurecr.io/${dest_img[$i]}:$dest_version"
  echo $pull_cmd
  $pull_cmd
  echo $tag_cmd
  $tag_cmd
  echo $push_cmd
  $push_cmd
  echo ""
done


