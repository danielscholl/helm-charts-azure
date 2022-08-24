# Common OSDU Helm Library

| `version`          | app-version  |
| ------------------- | ----------   |
| 0.2.0               | 0.16.0        |
| 0.1.0               | 0.11.0        |

## Add dependency of Helm Library__

Add the helm library dependency in the service chart for which you want to enable HPA as given below.

```yaml
dependencies:
  - name: "osdu-helm-library"
    version: ~0.2.0
    repository: file://../../osdu-helm-library
```

### Create template file and use the library template

Create `<service-name>.yaml` file under the same hierarchy as Chart.yaml of service and add following to it:  

```yaml
{{- include "osdu-helm-library.deployment" . }}
{{- include "osdu-helm-library.service" . }}
{{- include "osdu-helm-library.hpa" . }}
{{- include "osdu-helm-library.pbd" . }}
```

First services onboarded with template example are [secret.yaml](../osdu-azure/secret/templates/secret.yaml) and [eds-dms.yaml](../osdu-azure/eds-dms/templates/eds-dms.yaml)

## HPA Settings

### Populate Custom Values to enable the HPA

Add the following variable and define them as per the service requirements to enable HPA.

```yaml
global:
  ################################################################################
  # Specify the auto scale specific values
  #
 autoscale:
    enabled: true
    minReplicas: 2
    maxReplicas: 10
    scaleDownStabilizationSeconds: 60
    scaleDownPolicy: Max
    scaleUpStabilizationSeconds: 60
    scaleUpPolicy: Max
    scaleDownPolicies:
      - periodSeconds: 15
        type: Percent
        value: 40
    scaleUpPolicies:
      - periodSeconds: 15
        type: Pods
        value: 4
      - periodSeconds: 15
        type: Percent
        value: 100
    cpu:
        enabled: true
        averageUtilization: 60
```

### Test the HPA

To check if the HPA is configured well,after upgrading/installing the service chart follow the below command to get details of HPA.

```bash
# Setup Variables
Chart = Storage
Namespace= osdu-azure
kubectl describe hpa.v2beta2.autoscaling $Chart -n $Namespace
```
