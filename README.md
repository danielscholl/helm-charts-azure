# Helm Charts for installing OSDU on Azure

__Version Tracking__

| [osdu-base]  | [osdu-istio]   | [osdu-airflow]   | [osdu-azure]   |  [infrastucture]  |
| ------------ | -------------- | ---------------- | -------------- | ----------------- |
|  1.0.0       |  1.1.3         | 1.0.8            | 1.10.0         | 0.10.0            |
|  1.0.0       |  1.1.2         | 1.0.7            | 1.9.0          | 0.9.0             |
|  1.0.0       |  1.1.2         | 1.0.6            | 1.8.1          | 0.8.0             |
|  1.0.0       |  1.1.2         | 1.0.6            | 1.8.0          | 0.8.0             |
|  1.0.0       |  1.1.1         | 1.0.5            | 1.7.1          | 0.7.0             |
|  1.0.0       |  1.1.1         | 1.0.5            | 1.7.0          | 0.7.0             |
|  1.0.0       |  1.1.1         | 1.0.4            | 1.3.1          | 0.5.1             |
|  1.0.0       |  1.1.1         | 1.0.3            | 1.3.1          | 0.5.1             |
|  1.0.0       |  1.1.0         | 1.0.2            | 1.3.0          | 0.5.1             |
|  1.0.0       |  1.1.0         | 1.0.1            | 1.2.1          | azure-0.4.3       |
|  None        |  1.1.0         | 1.0.0            | 1.2.0          | azure-0.4.3       |
|  None        |  1.0.0         | None             | 1.1.0          | azure-0.4.2       |
|  None        |  1.0.0         | None             | 1.0.1          | 0.4.1             |
|  None        |  1.0.0         | None             | 1.0.0          | 0.4.0             |

__Installation Sequence__

Charts should be installed in the following order.

1. [osdu-base](osdu-base/README.md)
2. [osdu-istio](osdu-istio/README.md)
3. [osdu-airflow](osdu-airflow/README.md)
4. [osdu-azure](osdu-azure/README.md)
4. [ddms-*](osdu-ddms/README.md)

