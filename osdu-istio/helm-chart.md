# Helm Chart creation and upload for OSDU Istio on Azure

__Version Tracking__

| Helm Chart Version | istio-base   | istio-operator  |
| ------------------ | ------------ | --------------- |
| `1.1.5`            | `1.1.0`      | `1.7.0`         |
| `1.1.4`            | `1.1.0`      | `1.7.0`         |
| `1.1.3`            | `1.1.0`      | `1.7.0`         |
| `1.1.2`            | `1.1.0`      | `1.7.0`         |
| `1.1.1`            | `1.1.0`      | `1.7.0`         |
| `1.1.0`            | `1.1.0`      | `1.7.0`         |
| `1.0.0`            | `1.1.0`      | `1.7.0`         |


__Save and Push Helm Chart__

These commands should be executed at root level. i.e helm-charts-azure level.

```bash
# Setup Variables
CHART=osdu-istio
VERSION=1.1.5

# Save Chart
helm chart save $CHART msosdu.azurecr.io/helm/$CHART:$VERSION

# Push Chart
helm chart push msosdu.azurecr.io/helm/$CHART:$VERSION
```
