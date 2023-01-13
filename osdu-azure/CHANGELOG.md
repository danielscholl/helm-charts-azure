# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
[markdownlint](https://dlaa.me/markdownlint/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.19.0]

- Removed agic ingress in favor of istiogw+appgw [IAP!236](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/236) [!19](https://community.opengroup.org/osdu/platform/deployment-and-operations/helm-charts-azure/-/issues/19)

## [1.11.0] - 2021-09-13
- Onboarded dataset service
- Added feature flag for keda v2 to be used provided infra is updated to keda v2.
- The following services have been moved to new namespaces:
  1. Seismic Store Service
  2. Wellbore DDMS
- Well Delivery DDMS is still in 'osdu' namespace

## [1.10.0] - 2021-08-16
- Added nodeSelector field to support dedicated to services `services` k8s nodepool

## [1.9.0] - 2021-04-12

- OSDU Minor Release Upgrade - 0.9
- Added Services
  - Policy

## [1.8.0] - 2021-04-12

- OSDU Minor Release Upgrade - 0.8
- Added Envoy Filters
- Added Support for custom HTTPS Certificates
- Added Services
  - Entitlements v2
  - Wellbore DDMS
- Integrated Entitlements v2
- Deprecated Services
  - Entitlements v1
- Preview Services
  - OPA


## [1.7.1] - 2021-03-11

- Bug Fix File Service Swagger


## [1.7.0] - 2021-03-11

- OSDU Milestone 4 AppVersion (0.7)


## [1.4.0-rc1] - 2021-03-4

__DEVELOPER RELEASE__

- Service Version Upgrades


## [1.3.1] - 2021-02-22

- Bug Fix Workflow Service Ingress Paths

## [1.3.0] - 2021-02-12

- OSDU Milestone 3 AppVersion (0.5)
- Added Services
  - SDMS


## [1.2.1] - 2021-02-3

- Removed Certificate Issuer
- Renamed osdu-partition_base

## [1.2.0] - 2021-02-1

- Moved to Isolated Sub Charts
- Added Services
  - Schema
  - CRS Converter
  - WKS
  - Workflow
- Removed Services
  - Delivery

## [1.1.0] - 2020-12-30

- Added Services
  - Unit Service
  - CRS Catalog
  - Register
  - Notification

## [1.0.1] - 2020-11-30

- Added Services
  - File
  - Delivery

## [1.0.0] - 2020-11-12

- Initial Chart Support for Application
- Added Services
  - Partition
  - Entitlements
  - Legal
  - Storage
  - Indexer-Queue
  - Indexer
  - Search
