# submariner-operator

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
| operator.image.tag | string | `"0.14.0"` |  |
| operator.resources | object | `{}` |  |
| operator.tolerations | list | `[]` |  |
| submariner.cableDriver | string | `"libreswan"` |  |
| submariner.clusterCidr | string | `""` |  |
| submariner.clusterId | string | `""` |  |
| submariner.colorCodes | string | `"blue"` |  |
| submariner.coreDNSCustomConfig | object | `{}` |  |
| submariner.debug | bool | `false` |  |
| submariner.globalCidr | string | `""` |  |
| submariner.clustersetIpCidr | string | `""` |  |
| submariner.clustersetIpEnabled | bool | `false` |  |
| submariner.healthcheckEnabled | bool | `true` |  |
| submariner.images.repository | string | `"quay.io/submariner"` |  |
| submariner.images.tag | string | `"0.14.0"` |  |
| submariner.natEnabled | bool | `false` |  |
| submariner.serviceCidr | string | `""` |  |
| submariner.serviceDiscovery | bool | `true` |  |
| submariner.token | string | `""` |  |
