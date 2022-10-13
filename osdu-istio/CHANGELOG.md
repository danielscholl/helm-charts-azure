# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
[markdownlint](https://dlaa.me/markdownlint/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.7] - 2022-10

- Merged `azure/m12-master` branch to master for `osdu-istio/templates`.
- Fixed `osdu-cert` jobs to use appgw.
  - Needed to add VS and GW for health check in appgw on port 80 as well as rules for clusterissuer cert manager auto certificate update
  - `osdu-base` should have the istio ingress annotation to handle the cert manager certificate creation.
  - job will take care of upload the new created cert to the kv and update the KV, need to apply this change in infra [Infra Azure provisioning MR](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/merge_requests/738)

## [1.1.6] - 2022-09

- Merged `azure/m12-master` branch to master for `osdu-istio/templates`.
- Added custom specs for hpa and k8s resources in istiooperator, we were facing failures in glab and noticed that integration tests (Mostly for storage) were failing and istio gateway stopped to respond to the appgw, even when autoscaling was happening.
  - Scaled up `maxReplicas` for istiogw
  - Add `resiliency` option to storage service
  - [GatewaySpec](https://istio.io/latest/docs/reference/config/istio.operator.v1alpha1/#GatewaySpec)
  - [ResourceSpec](https://istio.io/latest/docs/reference/config/istio.operator.v1alpha1/#KubernetesResourcesSpec)
  - [Performance Summary](https://istio.io/latest/docs/ops/deployment/performance-and-scalability/#performance-summary-for-istio-hahahugoshortcode-s0-hbhb)

## [1.1.2] - 2021-02-1

- Removed Envoy Filters for Identity Providers to relocate to osdu-azure chart.

## [1.1.1] - 2021-02-1

- Envoy Filters for Identity Providers
- Remove unused Secret

## [1.1.0] - 2021-02-1

- Modifications for Istio Operator 1.8.2


## [1.0.0] - 2020-11-12

- Initial Chart Creation
