# Helm Chart creation and upload for OSDU on Azure

| `osdu-*-*`          | app-version  |
| ------------------- | ----------   |
| 1.18.0              | 0.18.0       |
| 1.15.0              | 0.15.0       |
| 1.13.0              | 0.13.0       |
| 1.12.0              | 0.12.0       |
| 1.11.0              | 0.11.0       |
| 1.10.0              | 0.10.0       |
| 1.9.0               | 0.9.0        |
| 1.8.1               | 0.8.0        |
| 1.8.0               | 0.8.0        |
| 1.7.1               | 0.7.0        |
| 1.4.0-rc1           | 0.6.0-rc1    |
| 1.3.1               | 0.5.0        |

__Save and Push Helm Chart__

We need to update dependent charts.Following are the commands to upgrade the dependencies and pushing the charts.Start from the root level i.e helm-charts-azure.

```bash

# Update helm dependency

cd osdu-azure/osdu-core_services
helm dependency update

cd ../osdu-security_compliance
helm dependency update

cd ../osdu-reference_helper
helm dependency update

cd ../osdu-partition_base
helm dependency update

cd ../osdu-ingest_enrich
helm dependency update


# Back to root level
cd ../../

# Setup Variables
CHART=osdu-azure
VERSION=1.13.0


# Save Chart
helm chart save $CHART msosdu.azurecr.io/helm/$CHART:$VERSION

# Push Chart
helm chart push msosdu.azurecr.io/helm/$CHART:$VERSION
```
