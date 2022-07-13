# submariner-operator

![Version: 0.12.2](https://img.shields.io/badge/Version-0.12.2-informational?style=flat-square) ![AppVersion: 0.12.2](https://img.shields.io/badge/AppVersion-0.12.2-informational?style=flat-square)

Submariner enables direct networking between Pods and Services in different Kubernetes clusters

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
| broker.ca | string | `""` |  |
| broker.globalnet | bool | `false` |  |
| broker.insecure | bool | `false` |  |
| broker.namespace | string | `"xyz"` |  |
| broker.server | string | `"example.k8s.apiserver"` |  |
| broker.token | string | `"test"` |  |
| gateway.image.repository | string | `"quay.io/submariner/submariner-gateway"` |  |
| gateway.image.tag | string | `"0.12.2"` |  |
| ipsec.debug | bool | `false` |  |
| ipsec.forceUDPEncaps | bool | `false` |  |
| ipsec.ikePort | int | `500` |  |
| ipsec.natPort | int | `4500` |  |
| ipsec.psk | string | `""` |  |
| leadership.leaseDuration | int | `10` |  |
| leadership.renewDeadline | int | `5` |  |
| leadership.retryPeriod | int | `2` |  |
| operator.affinity | object | `{}` |  |
| operator.image.pullPolicy | string | `"IfNotPresent"` |  |
| operator.image.repository | string | `"quay.io/submariner/submariner-operator"` |  |
| operator.image.tag | string | `"0.12.2"` |  |
| operator.resources | object | `{}` |  |
| operator.tolerations | list | `[]` |  |
| rbac.create | bool | `true` |  |
| serviceAccounts.gateway.create | bool | `true` |  |
| serviceAccounts.gateway.name | string | `""` |  |
| serviceAccounts.globalnet.create | bool | `true` |  |
| serviceAccounts.globalnet.name | string | `""` |  |
| serviceAccounts.lighthouseAgent.create | bool | `true` |  |
| serviceAccounts.lighthouseAgent.name | string | `""` |  |
| serviceAccounts.lighthouseCoreDns.create | bool | `true` |  |
| serviceAccounts.lighthouseCoreDns.name | string | `""` |  |
| serviceAccounts.operator.create | bool | `true` |  |
| serviceAccounts.operator.name | string | `""` |  |
| serviceAccounts.routeAgent.create | bool | `true` |  |
| serviceAccounts.routeAgent.name | string | `""` |  |
| submariner.cableDriver | string | `"libreswan"` |  |
| submariner.clusterCidr | string | `""` |  |
| submariner.clusterId | string | `""` |  |
| submariner.colorCodes | string | `"blue"` |  |
| submariner.coreDNSCustomConfig | object | `{}` |  |
| submariner.debug | bool | `false` |  |
| submariner.globalCidr | string | `""` |  |
| submariner.healthcheckEnabled | bool | `true` |  |
| submariner.images.repository | string | `"quay.io/submariner"` |  |
| submariner.images.tag | string | `"0.12.2"` |  |
| submariner.natEnabled | bool | `false` |  |
| submariner.serviceCidr | string | `""` |  |
| submariner.serviceDiscovery | bool | `true` |  |
| submariner.token | string | `""` |  |
