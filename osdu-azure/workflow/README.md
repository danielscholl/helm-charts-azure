# Helm Chart for OSDU on Azure Ingestion and Enrichment Services

| osdu-ingest_enrich  | app-version  |
| ------------------- | ----------   |
| 1.11.0               | 0.11.0        |
| 1.10.0               | 0.10.0        |
| 1.9.0               | 0.9.0        |
| 1.8.1               | 0.8.0        |
| 1.8.0               | 0.8.0        |
| 1.7.0               | 0.7.0        |
| 1.3.0               | 0.5.0        |
| 1.0.0               | 0.4.3        |

__Supported OSDU Services__

- [WKS Service](https://community.opengroup.org/osdu/platform/data-flow/enrichment/wks)
- [Ingest Workflow Service](https://community.opengroup.org/osdu/platform/data-flow/ingestion/ingestion-workflow)

### Airflow 2 Migration

To use Airflow1 as with the workflow service set the env variable in the values file to

| Env name | value |
| ---  | ---   |
| `OSDU_AIRFLOW_URL` | `http://airflow2-web.airflow2.svc.cluster.local:8080/airflow2` |
| `OSDU_AIRFLOW_VERSION2_ENABLED` | `true` |

The steps for creation of the airflow2 setup is document [here]().

### Revert to airflow 1.10.12

To use Airflow1 as with the workflow service set the env variable in the values file to

| Env name | value |
| ---  | ---   |
| `OSDU_AIRFLOW_URL` | `"http://airflow-web.airflow.svc.cluster.local:8080/airflow"` |
| `OSDU_AIRFLOW_VERSION2_ENABLED` | `false` |
    