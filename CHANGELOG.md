# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
[markdownlint](https://dlaa.me/markdownlint/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).


## App Version 0.5 (2021-2-12)

__Infrastructure Version:__ [release/0.5](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/tree/release/0.5)

__Charts__

| Chart         | OCI Package                         | Tag   |
| ------------- | ----------------------------------- | ----- |
| osdu-base     | msosdu.azurecr.io/helm/osdu-base    | 1.0.0 |
| osdu-istio    | msosdu.azurecr.io/helm/osdu-istio   | 1.1.0 |
| osdu-airflow  | msosdu.azurecr.io/helm/osdu-airflow | 1.0.2 |
| osdu-azure    | msosdu.azurecr.io/helm/osdu-azure   | 1.3.0 |


__Microsoft Images__

| Service          | Image                             | Tag   |
| ---------------- | --------------------------------- | ----- |
| Partition        | msosdu.azurecr.io/partition       | 0.5.0 |
| Entitlements     | msosdu.azurecr.io/entitlements    | 0.5.0 |
| Legal            | msosdu.azurecr.io/legal           | 0.5.0 |
| Storage          | msosdu.azurecr.io/storage         | 0.5.0 |
| Schema           | msosdu.azurecr.io/schema          | 0.5.0 |
| Indexer-Queue    | msosdu.azurecr.io/indexer-queue   | 0.5.0 |
| Indexer          | msosdu.azurecr.io/indexer         | 0.5.0 |
| Search           | msosdu.azurecr.io/search          | 0.5.0 |
| Delivery         | msosdu.azurecr.io/delivery        | 0.5.0 |
| File             | msosdu.azurecr.io/file            | 0.5.0 |
| Unit             | msosdu.azurecr.io/unit            | 0.5.0 |
| CRS-Catalog      | msosdu.azurecr.io/crs-catalog     | 0.5.0 |
| CRS-Conversion   | msosdu.azurecr.io/crs-conversion  | 0.5.0 |
| Register         | msosdu.azurecr.io/register        | 0.5.0 |
| Notification     | msosdu.azurecr.io/notification    | 0.5.0 |
| WKS              | msosdu.azurecr.io/wks             | 0.5.0 |
| Workflow         | msosdu.azurecr.io/workflow        | 0.5.0 |
| SDMS             | msosdu.azurecr.io/sdms            | 0.5.0 |


__Community Images__

| Service | Image | SHA/Tag |
| ------- | ----- | ------- |
| Partition     | community.opengroup.org:5555/osdu/platform/system/partition/partition-release-0-5 | [f9385bf561906a9ab3f2053989b1b329b47de4b3](https://community.opengroup.org/osdu/platform/system/partition/-/tree/release/0.5) |
| Entitlements  | community.opengroup.org:5555/osdu/platform/security-and-compliance/entitlements-azure/entitlements-azure-v0-5-0 | [0a090120039232cd75337cf4c40b5aadf62a3f58](https://community.opengroup.org/osdu/platform/security-and-compliance/entitlements-azure/-/tree/release/0.5) |
| Legal         | community.opengroup.org:5555/osdu/platform/security-and-compliance/legal/legal-v0-5-0 | [a180d14d6eb3f3a8573afc3e4e3dbe4306202182](https://community.opengroup.org/osdu/platform/security-and-compliance/legal/-/tree/release/0.5) |
| Storage       | community.opengroup.org:5555/osdu/platform/system/storage/storage-v0-5-0 | [83e00f253049b7b5c490f35b8b80b7b317421527](https://community.opengroup.org/osdu/platform/system/storage/-/tree/release/0.5) |
| Schema       | community.opengroup.org:5555/osdu/platform/system/schema-service/schema-service-release-0-5 | [5707b2ab35be9533607794a4dd46130df4aa9e96](https://community.opengroup.org/osdu/platform/system/schema-service/-/tree/release/0.5) |
| Indexer-Queue | community.opengroup.org:5555/osdu/platform/system/indexer-queue/indexer-queue-release-0-5 | [3d3d3a006ae0d7a8081661b059b1ec1b7eec78a6](https://community.opengroup.org/osdu/platform/system/indexer-queue/-/tree/release/0.5) |
| Indexer       | community.opengroup.org:5555/osdu/platform/system/indexer-service/indexer-service-release-0-5 | [ad66055f30937411db71ad9403cbc018f547f3dc](https://community.opengroup.org/osdu/platform/system/indexer-service/-/tree/release/0.5) |
| Search        | community.opengroup.org:5555/osdu/platform/system/search-service/search-service-v0-5-0 | [01a8c5e684223e8f7f85078ede05ab82f980063a](https://community.opengroup.org/osdu/platform/system/search-service/-/tree/release/0.5) |
| File          | community.opengroup.org:5555/osdu/platform/system/file/file-release-0-5 | [120a575c92fc9e5cedb885687d35a14d91c19a96](https://community.opengroup.org/osdu/platform/system/file/-/tree/release/0.5) |
| Unit          | community.opengroup.org:5555/osdu/platform/system/reference/unit-service/unit-service-v0-5-0 | [1a6a58aee7dd8a8628327e15405be916d97eb292](https://community.opengroup.org/osdu/platform/system/reference/unit-service/-/tree/release/0.5) |
| CRS-Catalog   | community.opengroup.org:5555/osdu/platform/system/reference/crs-catalog-service/crs-catalog-service-v0-5-0 | [eee80b4959355f911be8fd7fd7e0fc0f3e763fe9](https://community.opengroup.org/osdu/platform/system/reference/crs-catalog-service/-/tree/release/0.5) |
| CRS-Conversion  | community.opengroup.org:5555/osdu/platform/system/reference/crs-conversion-service/crs-conversion-service-v0-5-0 | [9b783cb9b6b649ea7175dd1f231f561ae20fef64](https://community.opengroup.org/osdu/platform/system/reference/crs-conversion-service/-/tree/release/0.5) |
| Register      | community.opengroup.org:5555/osdu/platform/system/register/register-release-0-5 | [f6126e03bc5bb3292a9db2b9c33697228ec7e866](https://community.opengroup.org/osdu/platform/system/register/-/tree/release/0.5) |
| Notification  | community.opengroup.org:5555/osdu/platform/system/notification/notification-release-0-5 | [caa5522253166d5a289e942ead7766575fa92630](https://community.opengroup.org/osdu/platform/system/notification/-/tree/release/0.5) |
| WKS           | community.opengroup.org:5555/osdu/platform/data-flow/enrichment/wks/wks-v0-5-0 | [1b1b2a883747f4aa6097b8ad16ca9b1063b3f850](https://community.opengroup.org/osdu/platform/data-flow/enrichment/wks/-/tree/release/0.5) |
| Workflow           | community.opengroup.org:5555/osdu/platform/data-flow/ingestion/ingestion-workflow/ingestion-workflow-release-0-5 | [5d418dd059aee4866addf6847c49d24eeccda0c1](https://community.opengroup.org/osdu/platform/data-flow/ingestion/ingestion-workflow/-/tree/release/0.5) |
| SDMS           | community.opengroup.org:5555/osdu/platform/domain-data-mgmt-services/seismic/seismic-dms-suite/seismic-store-service/seismic-store-service-v0-5-0 | [067f42a97ef1a93f1a06bfb03a07ada92bebaf31](https://community.opengroup.org/osdu/platform/domain-data-mgmt-services/seismic/seismic-dms-suite/seismic-store-service/-/tree/release/0.5) |




## App Version 0.4.3 (2021-1-25)

__Infrastructure Version:__ [tag/azure-0.4.3](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/tags/azure-0.4.3)

__Charts__

| Chart         | OCI Package                         | Tag   |
| ------------- | ----------------------------------- | ----- |
| osdu-istio    | msosdu.azurecr.io/helm/osdu-istio   | 1.1.0 |
| osdu-airflow  | msosdu.azurecr.io/helm/osdu-airflow | 1.0.0 |
| osdu-azure    | msosdu.azurecr.io/helm/osdu-azure   | 1.2.0 |


__Microsoft Images__

| Service          | Image                             | Tag   |
| ---------------- | --------------------------------- | ----- |
| Partition        | msosdu.azurecr.io/partition       | 0.4.3 |
| Entitlements     | msosdu.azurecr.io/entitlements    | 0.4.3 |
| Legal            | msosdu.azurecr.io/legal           | 0.4.3 |
| Storage          | msosdu.azurecr.io/storage         | 0.4.3 |
| Schema           | msosdu.azurecr.io/schema          | 0.4.3 |
| Indexer-Queue    | msosdu.azurecr.io/indexer-queue   | 0.4.3 |
| Indexer          | msosdu.azurecr.io/indexer         | 0.4.3 |
| Search           | msosdu.azurecr.io/search          | 0.4.3 |
| Delivery         | msosdu.azurecr.io/delivery        | 0.4.3 |
| File             | msosdu.azurecr.io/file            | 0.4.3 |
| Unit             | msosdu.azurecr.io/unit            | 0.4.3 |
| CRS-Catalog      | msosdu.azurecr.io/crs-catalog     | 0.4.3 |
| CRS-Conversion   | msosdu.azurecr.io/crs-conversion  | 0.4.3 |
| Register         | msosdu.azurecr.io/register        | 0.4.3 |
| Notification     | msosdu.azurecr.io/notification    | 0.4.3 |
| WKS              | msosdu.azurecr.io/wks             | 0.4.3 |
| Workflow         | msosdu.azurecr.io/workflow        | 0.4.3 |


__Community Images__

| Service | Image | SHA/Tag |
| ------- | ----- | ------- |
| Partition     | community.opengroup.org:5555/osdu/platform/system/partition/partition-master | [fc6f1fa97b0785e91051edec2a38a61a8f433e26](https://community.opengroup.org/osdu/platform/system/partition/-/tree/fc6f1fa97b0785e91051edec2a38a61a8f433e26) |
| Entitlements  | community.opengroup.org:5555/osdu/platform/security-and-compliance/entitlements-azure/entitlements-azure-master | [0edd0cbb95f14139794d2905b734bff9af1139ff](https://community.opengroup.org/osdu/platform/security-and-compliance/entitlements-azure/-/tree/0edd0cbb95f14139794d2905b734bff9af1139ff) |
| Legal         | community.opengroup.org:5555/osdu/platform/security-and-compliance/legal/legal-master | [5c805c30fc2f810699940f8a92b837baee1bd9ec](https://community.opengroup.org/osdu/platform/security-and-compliance/legal/-/tree/5c805c30fc2f810699940f8a92b837baee1bd9ec) |
| Storage       | community.opengroup.org:5555/osdu/platform/system/storage/storage-master | [d18b7c3598a7018405a2b8dd104f595e1eb76f7e](https://community.opengroup.org/osdu/platform/system/storage/-/tree/d18b7c3598a7018405a2b8dd104f595e1eb76f7e) |
| Schema       | community.opengroup.org:5555/osdu/platform/system/schema-service/schema-service-master | [40208dd3a76ca06da6b6363a5ea5d334f2f8b52c](https://community.opengroup.org/osdu/platform/system/schema-service/-/tree/40208dd3a76ca06da6b6363a5ea5d334f2f8b52c) |
| Indexer-Queue | community.opengroup.org:5555/osdu/platform/system/indexer-queue/indexer-queue-master | [85c09538370082b8aef8fba4bd4dacc239ccadbb](https://community.opengroup.org/osdu/platform/system/indexer-queue/-/tree/85c09538370082b8aef8fba4bd4dacc239ccadbb) |
| Indexer       | community.opengroup.org:5555/osdu/platform/system/indexer-service/indexer-service-master | [32c4c9827adf97aa8ac0d0952ca23cae25cdb944](https://community.opengroup.org/osdu/platform/system/indexer-service/-/tree/32c4c9827adf97aa8ac0d0952ca23cae25cdb944) |
| Search        | community.opengroup.org:5555/osdu/platform/system/search-service/search-service-master | [60dc4c431405c1fef1fd964e3e95105691bd1568](https://community.opengroup.org/osdu/platform/system/search-service/-/tree/60dc4c431405c1fef1fd964e3e95105691bd1568) |
| Delivery      | community.opengroup.org:5555/osdu/platform/system/delivery/delivery-master | [805197d60656330229a0879d7ad407eec4f254d4](https://community.opengroup.org/osdu/platform/system/delivery/-/tree/805197d60656330229a0879d7ad407eec4f254d4) |
| File          | community.opengroup.org:5555/osdu/platform/system/file/file-master | [d5918b6f2f01881415045f5731bcc0da5f586755](https://community.opengroup.org/osdu/platform/system/file/-/tree/d5918b6f2f01881415045f5731bcc0da5f586755) |
| Unit          | community.opengroup.org:5555/osdu/platform/system/reference/unit-service/unit-service-master | [b40b14b34aa263089c952c1b72fecde2f36c0ecb](https://community.opengroup.org/osdu/platform/system/reference/unit-service/-/tree/b40b14b34aa263089c952c1b72fecde2f36c0ecb) |
| CRS-Catalog   | community.opengroup.org:5555/osdu/platform/system/reference/crs-catalog-service/crs-catalog-service-master | [4363f20ebb315a912359d8388ff0dcecb2eb49dc](https://community.opengroup.org/osdu/platform/system/reference/crs-catalog-service/-/tree/4363f20ebb315a912359d8388ff0dcecb2eb49dc) |
| CRS-Conversion  | community.opengroup.org:5555/osdu/platform/system/reference/crs-conversion-service/crs-conversion-service-master | [4363f20ebb315a912359d8388ff0dcecb2eb49dc](https://community.opengroup.org/osdu/platform/system/reference/crs-conversion-service/-/tree/4363f20ebb315a912359d8388ff0dcecb2eb49dc) |
| Register      | community.opengroup.org:5555/osdu/platform/system/register/register-master | [9558848651c0eb964a5e2b3d4189f1064de30789](https://community.opengroup.org/osdu/platform/system/register/-/tree/9558848651c0eb964a5e2b3d4189f1064de30789) |
| Notification  | community.opengroup.org:5555/osdu/platform/system/notification/notification-master | [2cd2d058196add71824784c7c9b0e736f55a6cc7](https://community.opengroup.org/osdu/platform/system/notification/-/tree/2cd2d058196add71824784c7c9b0e736f55a6cc7) |
| WKS           | community.opengroup.org:5555/osdu/platform/data-flow/enrichment/wks/wks-master | [118bc73b1ccd8e40740a1691acd7bfb8a1c8ec80](https://community.opengroup.org/osdu/platform/data-flow/enrichment/wks/-/tree/118bc73b1ccd8e40740a1691acd7bfb8a1c8ec80) |
| Workflow           | ccommunity.opengroup.org:5555/osdu/platform/data-flow/ingestion/ingestion-workflow/ingestion-workflow-master | [a11c145e6d7cf2649fc51c8c76facc01937650d5](https://community.opengroup.org/osdu/platform/data-flow/ingestion/ingestion-workflow/-/tree/a11c145e6d7cf2649fc51c8c76facc01937650d5) |




## App Version 0.4.2 (2020-12-30)

__Infrastructure Version:__ [tag/azure-0.4.2](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/tags/azure-0.4.2)

__Charts__

| Chart         | OCI Package                         | Tag   |
| ------------- | ----------------------------------- | ----- |
| osdu-istio    | msosdu.azurecr.io/helm/osdu-istio   | 1.0.0 |
| osdu-airflow  | _None_                              |       |
| osdu-azure    | msosdu.azurecr.io/helm/osdu-azure   | 1.1.0 |


__Microsoft Images__

| Service       | Image                             | Tag   |
| ------------- | --------------------------------- | ----- |
| Partition     | msosdu.azurecr.io/partition       | 0.4.2 |
| Entitlements  | msosdu.azurecr.io/entitlements    | 0.4.2 |
| Legal         | msosdu.azurecr.io/legal           | 0.4.2 |
| Storage       | msosdu.azurecr.io/storage         | 0.4.2 |
| Indexer-Queue | msosdu.azurecr.io/indexer-queue   | 0.4.2 |
| Indexer       | msosdu.azurecr.io/indexer         | 0.4.2 |
| Search        | msosdu.azurecr.io/search          | 0.4.2 |
| Delivery      | msosdu.azurecr.io/delivery        | 0.4.2 |
| File          | msosdu.azurecr.io/file            | 0.4.2 |
| Unit          | msosdu.azurecr.io/unit            | 0.4.2 |
| CRS-Catalog   | msosdu.azurecr.io/crs-catalog     | 0.4.2 |
| Register      | msosdu.azurecr.io/register        | 0.4.2 |
| Notification  | msosdu.azurecr.io/notification    | 0.4.2 |


__Community Images__

| Service | Image | SHA/Tag |
| ------- | ----- | ------- |
| Partition     | community.opengroup.org:5555/osdu/platform/system/partition/partition-master | [70835dc1ae36585a1ebc634838a937f8cd6c0901](https://community.opengroup.org/osdu/platform/system/partition/-/tree/70835dc1ae36585a1ebc634838a937f8cd6c0901) |
| Entitlements  | community.opengroup.org:5555/osdu/platform/security-and-compliance/entitlements-azure/entitlements-azure-master | [0edd0cbb95f14139794d2905b734bff9af1139ff](https://community.opengroup.org/osdu/platform/security-and-compliance/entitlements-azure/-/tree/0edd0cbb95f14139794d2905b734bff9af1139ff) |
| Legal         | community.opengroup.org:5555/osdu/platform/security-and-compliance/legal/legal-master | [08f8dd456f46f8a2e197c046ed6986034d56d012](https://community.opengroup.org/osdu/platform/security-and-compliance/legal/-/tree/08f8dd456f46f8a2e197c046ed6986034d56d012) |
| Storage       | community.opengroup.org:5555/osdu/platform/system/storage/storage-master | [d9d01eacc8370ff90c3960b9ec0c534b74b6f23f](https://community.opengroup.org/osdu/platform/system/storage/-/tree/d9d01eacc8370ff90c3960b9ec0c534b74b6f23f) |
| Indexer-Queue | community.opengroup.org:5555/osdu/platform/system/indexer-queue/indexer-queue-master | [a286fea7cd34417d7ecf0cc5f7694b0d3f19ce2f](https://community.opengroup.org/osdu/platform/system/indexer-queue/-/tree/a286fea7cd34417d7ecf0cc5f7694b0d3f19ce2f) |
| Indexer       | community.opengroup.org:5555/osdu/platform/system/indexer-service/indexer-service-master | [c82aa9cdcb9167f88085c01fe350d7507f741886](https://community.opengroup.org/osdu/platform/system/indexer-service/-/tree/c82aa9cdcb9167f88085c01fe350d7507f741886) |
| Search        | community.opengroup.org:5555/osdu/platform/system/search-service/search-service-master | [0e77e3b1af43e472c865e731d67681143c1550ce](https://community.opengroup.org/osdu/platform/system/search-service/-/tree/0e77e3b1af43e472c865e731d67681143c1550ce) |
| Delivery      | community.opengroup.org:5555/osdu/platform/system/delivery/delivery-master | [22309d46469e2e4f361fdc73d0e2ef329a6f927c](https://community.opengroup.org/osdu/platform/system/delivery/-/tree/22309d46469e2e4f361fdc73d0e2ef329a6f927c) |
| File          | community.opengroup.org:5555/osdu/platform/system/file/file-master | [1f1d640c50e8d2296ff0640fe67d53cc507d09de](https://community.opengroup.org/osdu/platform/system/file/-/tree/1f1d640c50e8d2296ff0640fe67d53cc507d09de) |
| Unit          | community.opengroup.org:5555/osdu/platform/system/reference/unit-service/unit-service-master | [a6d4280f3d535d478bd8fb2a31dfa0dc86c04ce6](https://community.opengroup.org/osdu/platform/system/reference/unit-service/-/tree/a6d4280f3d535d478bd8fb2a31dfa0dc86c04ce6) |
| CRS-Catalog   | community.opengroup.org:5555/osdu/platform/system/reference/crs-catalog-service/crs-catalog-service-master | [c3136d33822be097502c5b7ce88134262cea58e5](https://community.opengroup.org/osdu/platform/system/reference/crs-catalog-service/-/tree/c3136d33822be097502c5b7ce88134262cea58e5) |
| Register      | community.opengroup.org:5555/osdu/platform/system/register/register-master | [d2dbf184c1f8406df76ee0ea01b47eac40b406aa](https://community.opengroup.org/osdu/platform/system/register/-/tree/d2dbf184c1f8406df76ee0ea01b47eac40b406aa) |
| Notification  | community.opengroup.org:5555/osdu/platform/system/notification/notification-master | [75472600951bd6479e9d8b21b4a0ed0f764bfd43](https://community.opengroup.org/osdu/platform/system/notification/-/tree/75472600951bd6479e9d8b21b4a0ed0f764bfd43) |


## App Version 0.4.1 (2020-11-30)

__Infrastructure Version:__  [tag/v0.4.1](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/tags/v0.4.1)

__Charts__

| Chart         | OCI Package                         | Tag   |
| ------------- | ----------------------------------- | ----- |
| osdu-istio    | msosdu.azurecr.io/helm/osdu-istio   | 1.0.0 |
| osdu-airflow  | _None_                              |       |
| osdu-azure    | msosdu.azurecr.io/helm/osdu-azure   | 1.0.1 |


__Microsoft Images__

| Service       | Image                             | Tag   |
| ------------- | --------------------------------- | ----- |
| Partition     | msosdu.azurecr.io/partition       | 0.4.1 |
| Entitlements  | msosdu.azurecr.io/entitlements    | 0.4.1 |
| Legal         | msosdu.azurecr.io/legal           | 0.4.1 |
| Storage       | msosdu.azurecr.io/storage         | 0.4.1 |
| Indexer-Queue | msosdu.azurecr.io/indexer-queue   | 0.4.1 |
| Indexer       | msosdu.azurecr.io/indexer         | 0.4.1 |
| Search        | msosdu.azurecr.io/search          | 0.4.1 |
| Delivery      | msosdu.azurecr.io/delivery        | 0.4.1 |
| File          | msosdu.azurecr.io/file            | 0.4.1 |


__Community Images__

| Service | Image | Tag |
| ------- | ----- | --- |
| Partition     | community.opengroup.org:5555/osdu/platform/system/partition/partition-master | [3a50a7048c7dd39ef689e87af6ee745f5a57b3b3](https://community.opengroup.org/osdu/platform/system/partition/-/tree/3a50a7048c7dd39ef689e87af6ee745f5a57b3b3) |
| Entitlements  | community.opengroup.org:5555/osdu/platform/security-and-compliance/entitlements-azure/entitlements-azure-master | [70b889b47be7ed01956db0305ad888e61e06387c](https://community.opengroup.org/osdu/platform/security-and-compliance/entitlements-azure/-/tree/70b889b47be7ed01956db0305ad888e61e06387c) |
| Legal         | community.opengroup.org:5555/osdu/platform/security-and-compliance/legal/legal-master | [70abc2ab72050a9795e63d6900f2b5f825173ad7](https://community.opengroup.org/osdu/platform/security-and-compliance/legal/-/tree/70abc2ab72050a9795e63d6900f2b5f825173ad7) |
| Storage       | community.opengroup.org:5555/osdu/platform/system/storage/storage-master | [93b5636ba43bcd907c34ba61fcc00aba47349597](https://community.opengroup.org/osdu/platform/system/storage/-/tree/93b5636ba43bcd907c34ba61fcc00aba47349597) |
| Indexer-Queue | community.opengroup.org:5555/osdu/platform/system/indexer-queue/indexer-queue-master | [4b56366f90f2fb6ba904ab9ba672a0595e9a6a4b](https://community.opengroup.org/osdu/platform/system/indexer-queue/-/tree/4b56366f90f2fb6ba904ab9ba672a0595e9a6a4b) |
| Indexer       | community.opengroup.org:5555/osdu/platform/system/indexer-service/indexer-service-master | [f0699e2af5e96eb1e853d6785f9abe97e87ba39d](https://community.opengroup.org/osdu/platform/system/indexer-service/-/tree/f0699e2af5e96eb1e853d6785f9abe97e87ba39d) |
| Search        | community.opengroup.org:5555/osdu/platform/system/search-service/search-service-master | [c42afcb11c0b36229cc2b2803f4e15958232d95a](https://community.opengroup.org/osdu/platform/system/search-service/-/tree/c42afcb11c0b36229cc2b2803f4e15958232d95a) |
| Delivery      | community.opengroup.org:5555/osdu/platform/system/delivery/delivery-master | [16a935048c6e9ace219d08fd3feb718a4b1d7abf](https://community.opengroup.org/osdu/platform/system/delivery/-/tree/16a935048c6e9ace219d08fd3feb718a4b1d7abf) |
| File          | community.opengroup.org:5555/osdu/platform/system/file/file-master | [1144aa06e6b70df8e1c06ccc6331cb78a79951cc](https://community.opengroup.org/osdu/platform/system/file/-/tree/1144aa06e6b70df8e1c06ccc6331cb78a79951cc) |



## App Version 0.4.0 (2020-11-12)

__Infrastructure Version:__  [release/0.4](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/tree/release/0.4)

__Charts__

| Chart         | OCI Package                         | Tag   |
| ------------- | ----------------------------------- | ----- |
| osdu-istio    | msosdu.azurecr.io/helm/osdu-istio   | 1.0.0 |
| osdu-airflow  | _None_                              |       |
| osdu-azure    | msosdu.azurecr.io/helm/osdu-azure   | 1.0.0 |


__Community Images__

| Service | Image | Tag |
| ------- | ----- | --- |
| Partition     | community.opengroup.org:5555/osdu/platform/system/partition/partition-release-0-4 | [81976630aa9de9abd508a32a7f0ef1f9a773a1ab](https://community.opengroup.org/osdu/platform/system/partition/-/tree/release/0.4) |
| Entitlements  | community.opengroup.org:5555/osdu/platform/security-and-compliance/entitlements-azure/entitlements-azure-release-0-4 | [32fb4035378213354dedb90bb1549deb44e5f2df](https://community.opengroup.org/osdu/platform/security-and-compliance/entitlements-azure/-/tree/release/0.4) |
| Legal         | community.opengroup.org:5555/osdu/platform/security-and-compliance/legal/legal-release-0-4 | [96dd3c699e0fa344a69e63acd75c83bafadab94f](https://community.opengroup.org/osdu/platform/security-and-compliance/legal/-/tree/release/0.4) |
| Storage       | community.opengroup.org:5555/osdu/platform/system/storage/storage-release-0-4 | [4eb302c39db1956d2e5098ec87399526176d14a5](https://community.opengroup.org/osdu/platform/system/storage/-/tree/release/0.4) |
| Indexer-Queue | community.opengroup.org:5555/osdu/platform/system/indexer-queue/indexer-queue-release-0-4 | [a3ea5d8629fed60058332672d7b871606041ee96](https://community.opengroup.org/osdu/platform/system/indexer-queue/-/tree/release/0.4) |
| Indexer       | community.opengroup.org:5555/osdu/platform/system/indexer-service/indexer-service-release-0-4 | [c1cde375c3c76e84290efb63405edf81ec964ff3](https://community.opengroup.org/osdu/platform/system/indexer-service/-/tree/release/0.4) |
| Search        | community.opengroup.org:5555/osdu/platform/system/search-service/search-service-release-0-4 | [834269ff32812c3cdfc42f315d3c7eb01fda622e](https://community.opengroup.org/osdu/platform/system/search-service/-/tree/release/0.4) |


__Microsoft Images__

| Service       | Image                           | Tag   |
| ------------- | ------------------------------- | ----- |
| Partition     | msosdu.azurecr.io/partition     | 0.4.0 |
| Entitlements  | msosdu.azurecr.io/entitlements  | 0.4.0 |
| Legal         | msosdu.azurecr.io/legal         | 0.4.0 |
| Storage       | msosdu.azurecr.io/storage       | 0.4.0 |
| Indexer-Queue | msosdu.azurecr.io/indexer-queue | 0.4.0 |
| Indexer       | msosdu.azurecr.io/indexer       | 0.4.0 |
| Search        | msosdu.azurecr.io/search        | 0.4.0 |
| Delivery      | msosdu.azurecr.io/delivery      | 0.4.0 |
| File          | msosdu.azurecr.io/file          | 0.4.0 |
