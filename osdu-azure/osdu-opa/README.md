# Helm Chart for OSDU on Azure Open Policy Agent

| osdu-opa  | app-version   |
| ------------------------- | ----------   |
| 1.1.17                    | 0.44.0       |
| 1.0.0                     | 0.13.0        |
| 1.0.0                     | 0.12.0        |
| 1.0.0                     | 0.11.0        |
| 1.0.0                     | 0.10.0        |
| 1.0.0                     | 0.9.0        |
| 1.0.0                     | 0.8.0        |

## Important notes

OPA will be in `non-ready` state until correctly loads the azure storage account bundles, this will lead to non-success installation in environments which are not already filled in with default policies.

## Useful references

* [Default policies](https://community.opengroup.org/osdu/platform/security-and-compliance/policy/-/tree/release/0.17/deployment/default-policies)
* [Policy Setup](https://community.opengroup.org/osdu/platform/security-and-compliance/policy/-/wikis/home#setup)
* [Persisting Azure Policy bundles](https://community.opengroup.org/osdu/platform/security-and-compliance/policy/-/wikis/Persisting-policies-and-autoscaling#azure)
