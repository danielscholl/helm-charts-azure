# Helm Chart creation and upload for OSDU DDMS on Azure

| `ddms-*-*`          | app-version  |
| ------------------- | ----------   |
| 1.13.0               | 0.13.0       |
| 1.12.0               | 0.12.0        |
| 1.11.0               | 0.11.0        |
| 1.9.0               | 0.9.0        |


__Save and Push Helm Chart__

Following commands need to be executed from root level.i.e helm-charts-azure

```bash
# Setup Variables
CHART=osdu-ddms
VERSION=1.13.0

# Save Chart
helm chart save $CHART msosdu.azurecr.io/helm/$CHART:$VERSION

# Push Chart
helm chart push msosdu.azurecr.io/helm/$CHART:$VERSION
```
