# Helm Library for HPA

| `version`          | app-version  |
| ------------------- | ----------   |
| 0.1.0               | 0.11.0        |

__Add dependency of Helm Library__

Add the helm library dependency in the service chart for which you want to enable HPA as given below.

``` yaml
dependencies:
  - name: "helm-library"
    version: "0.1.0"
    repository: file://../helm-library
    enabled: true
```

__Create HPA file and use the library template__

Create hpa.yaml file under the same hierarchy as Chart.yaml of service and add following to it:  

```bash
{{- include "helm-library.hpa" . }}
```

__Populate Custom Values to enable the HPA__
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

__Test the HPA__

To check if the HPA is configured well,after upgrading/installing the service chart follow the below command to get details of HPA.
```bash
# Setup Variables
Chart = Storage
Namespace= osdu-azure
kubectl describe hpa.v2beta2.autoscaling $Chart -n $Namespace
```