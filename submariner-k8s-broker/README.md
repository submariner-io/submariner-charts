# submariner-k8s-broker

![Version: 0.13.0](https://img.shields.io/badge/Version-0.13.0-informational?style=flat-square) ![AppVersion: 0.13.0](https://img.shields.io/badge/AppVersion-0.13.0-informational?style=flat-square)

Submariner Kubernetes Broker

**Homepage:** <https://submariner-io.github.io/>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Contributors to the Submariner project | submariner-dev@googlegroups.com | https://submariner.io/ |

## Source Code

* <https://submariner-io.github.io/submariner-charts/charts>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| crd.create | bool | `true` |  |
| rbac.create | bool | `true` |  |
| serviceAccounts.client.create | bool | `true` |  |
| serviceAccounts.client.name | string | `""` |  |
