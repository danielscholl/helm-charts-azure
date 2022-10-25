# Helm Charts for installing OSDU on Azure

Helm supported version: __3.9.x__ for kubeclient __1.24.x - 1.21.x__ (More info in [Supported Versions Skew](https://helm.sh/docs/topics/version_skew/#supported-version-skew))

__Version Tracking__

| [osdu-base]  | [osdu-istio]   | [osdu-airflow]   | [osdu-azure]   |  [infrastucture]  |   [osdu-ddms]     |
| ------------ | -------------- | ---------------- | -------------- | ----------------- | ----------------- |
|  1.0.0       |  1.1.6         | airflow2 - 1.17.0 | 1.17.0         | 0.17.0, 0.16.0   | 1.17.0 |
|  1.0.0       |  1.1.6         | airflow2 - 1.16.0 | 1.16.0         | 0.16.0 __AKS 1.24__ | 1.16.0 |
|  1.0.0       |  1.1.5         | airflow1-1.0.11 , airflow2- 1.10.1 | 1.15.0         | 0.15.0            | 1.15.0 |
|  1.0.0       |  1.1.5         | airflow1-1.0.11 , airflow2- 1.10.1 | 1.13.0         | 0.13.0            | 1.13.0 |
|  1.0.0       |  1.1.4         | 1.0.10           | 1.12.0         | 0.12.0            | 1.12.0
|  1.0.0       |  1.1.3         | 1.0.9            | 1.11.0         | 0.11.0            | 1.11.0             |
|  1.0.0       |  1.1.3         | 1.0.8            | 1.10.0         | 0.10.0            |                   |
|  1.0.0       |  1.1.2         | 1.0.7            | 1.9.0          | 0.9.0             |                   |
|  1.0.0       |  1.1.2         | 1.0.6            | 1.8.1          | 0.8.0             |                   |
|  1.0.0       |  1.1.2         | 1.0.6            | 1.8.0          | 0.8.0             |                   |
|  1.0.0       |  1.1.1         | 1.0.5            | 1.7.1          | 0.7.0             |                   |
|  1.0.0       |  1.1.1         | 1.0.5            | 1.7.0          | 0.7.0             |                   |
|  1.0.0       |  1.1.1         | 1.0.4            | 1.3.1          | 0.5.1             |                   |
|  1.0.0       |  1.1.1         | 1.0.3            | 1.3.1          | 0.5.1             |                   |
|  1.0.0       |  1.1.0         | 1.0.2            | 1.3.0          | 0.5.1             |                   |
|  1.0.0       |  1.1.0         | 1.0.1            | 1.2.1          | azure-0.4.3       |                   |
|  None        |  1.1.0         | 1.0.0            | 1.2.0          | azure-0.4.3       |                   |
|  None        |  1.0.0         | None             | 1.1.0          | azure-0.4.2       |                   |
|  None        |  1.0.0         | None             | 1.0.1          | 0.4.1             |                   |
|  None        |  1.0.0         | None             | 1.0.0          | 0.4.0             |                   |

__Installation Sequence__

Charts should be installed in the following order.

1. [osdu-base](osdu-base/README.md)
2. [osdu-istio](osdu-istio/README.md)
3. [osdu-airflow](osdu-airflow/README.md) or [osdu-airflow2](osdu-airflow2/README.md)*
4. [osdu-azure](osdu-azure/README.md)
5. [ddms-*](osdu-ddms/README.md)

__*Microsoft recommends installing osdu-airflow2 helm chart for OSDU platform.__

[Helm validation and template test](./scripts/tests/README.md)
