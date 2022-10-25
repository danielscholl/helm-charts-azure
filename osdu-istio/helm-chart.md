# Helm Chart creation and upload for OSDU Istio on Azure

__Version Tracking__

| Helm Chart Version | istio-base   | istio-operator  |
| ------------------ | ------------ | --------------- |
| `1.1.8`            | `1.15.2`     | `1.15.2`        |
| `1.1.7`            | `1.1.0`      | `1.8.0`         |
| `1.1.6`            | `1.1.0`      | `1.8.0`         |
| `1.1.5`            | `1.1.0`      | `1.7.0`         |
| `1.1.4`            | `1.1.0`      | `1.7.0`         |
| `1.1.3`            | `1.1.0`      | `1.7.0`         |
| `1.1.2`            | `1.1.0`      | `1.7.0`         |
| `1.1.1`            | `1.1.0`      | `1.7.0`         |
| `1.1.0`            | `1.1.0`      | `1.7.0`         |
| `1.0.0`            | `1.1.0`      | `1.7.0`         |

## Developer notes

Getting istio packages from official istio release.

```shell
ISTIO_VERSION=1.15.2
helm pull --repo https://istio-release.storage.googleapis.com/charts --version $ISTIO_VERSION base
git clone  --single-branch --branch $ISTIO_VERSION --depth 1 https://github.com/istio/istio.git /tmp/istio
helm package /tmp/istio/manifests/charts/istio-operator/ --destination . --version $ISTIO_VERSION
```

3 Images should be updated:

* istio/operator
* istio/pilot
* istio/proxyv2

## Save and Push Helm Chart

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
