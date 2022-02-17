# Helm Chart creation and upload for OSDU on Azure Base

__Version Tracking__

| Helm Chart Version |
| ------------------ |
| `1.0.0`            |


__Save and Push Helm Chart__

These commands should be executed at root level. i.e helm-charts-azure level.

```bash
# Setup Variables
CHART=osdu-base
VERSION=1.0.0

# Save Chart
helm chart save $CHART msosdu.azurecr.io/helm/$CHART:$VERSION

# Push Chart to ACR
helm chart push msosdu.azurecr.io/helm/$CHART:$VERSION
```