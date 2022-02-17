# Helm Chart creation and upload for OSDU on Azure Airflow

__Version Tracking__

| Helm Chart Version | airflow     | statsd  |
| ------------------ | ----------- |-------- |
| `1.0.x`            | `8.5.2`     | `1.0.0` |


__Save and Push Helm Chart__

Following commands need to be executed from root level.i.e helm-charts-azure

```bash
# Setup Variables
CHART=osdu-airflow2
VERSION=1.10.1

# Update dependencies
helm dependency update

# Save Chart
helm chart save $CHART msosdu.azurecr.io/helm/$CHART:$VERSION

# Push Chart
helm chart push msosdu.azurecr.io/helm/$CHART:$VERSION
```
