# Helm Charts for OSDU on Azure

__Compatability Matrix__

| [osdu-istio](osdu-istio/README.md)   | [osdu-airflow](osdu-airflow/README.md)   | [osdu-azure](osdu-azure/README.md)   |  [infrastucture](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/tree/master/infra/templates/osdu-r3-mvp)     |
| ------------------------------------ | ---------------------------------------- | ------------------------------------ | ------------------ |
|  1.0.0                               | None                                     | 1.1.0                                | azure-0.4.2        |
|  1.0.0                               | None                                     | 1.0.1                                | 0.4.1              |
|  1.0.0                               | None                                     | 1.0.0                                | 0.4.0              |


# App Version 0.4.2 (2020-12-30)

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


# App Version 0.4.1 (2020-11-30)

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



# App Version 0.4.0 (2020-11-12)

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
