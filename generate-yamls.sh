#!/bin/bash

set -e

BROKER_ROLE_TPL=submariner-k8s-broker/templates/_role.tpl
OPERATOR_RBAC_YAML=submariner-operator/templates/operator-rbac.yaml
GATEWAY_RBAC_YAML=submariner-operator/templates/gateway-rbac.yaml
ROUTE_AGENT_RBAC_YAML=submariner-operator/templates/routeagent-rbac.yaml
GLOBALNET_RBAC_YAML=submariner-operator/templates/globalnet-rbac.yaml
SERVICE_DISC_RBAC_YAML=submariner-operator/templates/service-discovery-rbac.yaml
OPENSHIFT_MONITORING_YAML=submariner-operator/templates/openshift-monitoring-rbac.yaml

YAMLS_BASE=yamls/vendor
SUBM_CRDS=${YAMLS_BASE}/github.com/submariner-io/submariner/deploy/crds
OPERATOR_CRDS=${YAMLS_BASE}/github.com/submariner-io/submariner-operator/deploy/crds
MCS_CRDS=${YAMLS_BASE}/sigs.k8s.io/mcs-api/config/crd
BROKER=${YAMLS_BASE}/github.com/submariner-io/submariner-operator/config/broker/broker-client
RBAC_BASE=${YAMLS_BASE}/github.com/submariner-io/submariner-operator/config/rbac
OPENSHIFT=${YAMLS_BASE}/github.com/submariner-io/submariner-operator/config/openshift

function add_service_acct_ns() {
    sed -i '/- kind: ServiceAccount/a \ \ \ \ namespace: {{ .Release.Namespace }}' $1
}

cd yamls
rm go.mod || true
go mod init
go get github.com/submariner-io/submariner-operator@$1
go mod tidy
go mod vendor
cd ..

# Generate the CRDs for the broker chart
mkdir -p submariner-k8s-broker/crds
cat ${SUBM_CRDS}/submariner.io_endpoints.yaml \
	  ${SUBM_CRDS}/submariner.io_clusters.yaml \
		${SUBM_CRDS}/submariner.io_gateways.yaml > submariner-k8s-broker/crds/crd.yaml
echo '---' >> submariner-k8s-broker/crds/crd.yaml
cat ${MCS_CRDS}/multicluster.x-k8s.io_serviceexports.yaml >> submariner-k8s-broker/crds/crd.yaml
echo '---' >> submariner-k8s-broker/crds/crd.yaml
cat ${MCS_CRDS}/multicluster.x-k8s.io_serviceimports.yaml >> submariner-k8s-broker/crds/crd.yaml

# Generate the client role yaml for the broker chart
echo '{{- define "broker-role" -}}' > ${BROKER_ROLE_TPL}
cat ${BROKER}/role.yaml >> ${BROKER_ROLE_TPL}
echo '{{- end -}}' >> ${BROKER_ROLE_TPL}
sed -i -e 's/name:.*/name: {{ template "submariner-k8s-broker.fullname" \. }}-cluster/' ${BROKER_ROLE_TPL}

# Generate the CRDs for the operator chart
mkdir -p submariner-operator/crds
cat ${OPERATOR_CRDS}/submariner.io_submariners.yaml \
    ${OPERATOR_CRDS}/submariner.io_servicediscoveries.yaml \
    ${OPERATOR_CRDS}/submariner.io_brokers.yaml > submariner-operator/crds/crd.yaml

# Generate the operator RBAC yaml for the operator chart
add_service_acct_ns ${RBAC_BASE}/submariner-operator/cluster_role_binding.yaml
cat ${RBAC_BASE}/submariner-operator/service_account.yaml \
    ${RBAC_BASE}/submariner-operator/role.yaml \
    ${RBAC_BASE}/submariner-operator/role_binding.yaml \
    ${RBAC_BASE}/submariner-operator/cluster_role.yaml \
    ${RBAC_BASE}/submariner-operator/cluster_role_binding.yaml > ${OPERATOR_RBAC_YAML}

# Generate the gateway RBAC yaml for the operator chart
add_service_acct_ns ${RBAC_BASE}/submariner-gateway/cluster_role_binding.yaml
cat ${RBAC_BASE}/submariner-gateway/service_account.yaml \
    ${RBAC_BASE}/submariner-gateway/role.yaml \
    ${RBAC_BASE}/submariner-gateway/role_binding.yaml \
    ${RBAC_BASE}/submariner-gateway/cluster_role.yaml \
    ${RBAC_BASE}/submariner-gateway/cluster_role_binding.yaml > ${GATEWAY_RBAC_YAML}

# Generate the routeagent RBAC yaml for the operator chart
add_service_acct_ns ${RBAC_BASE}/submariner-route-agent/cluster_role_binding.yaml
cat ${RBAC_BASE}/submariner-route-agent/service_account.yaml \
    ${RBAC_BASE}/submariner-route-agent/role.yaml \
    ${RBAC_BASE}/submariner-route-agent/role_binding.yaml \
    ${RBAC_BASE}/submariner-route-agent/cluster_role.yaml \
    ${RBAC_BASE}/submariner-route-agent/cluster_role_binding.yaml > ${ROUTE_AGENT_RBAC_YAML}

# Generate the globalnet RBAC yaml for the operator chart
echo '{{- if .Values.broker.globalnet }}' > ${GLOBALNET_RBAC_YAML}
add_service_acct_ns ${RBAC_BASE}/submariner-globalnet/cluster_role_binding.yaml
cat ${RBAC_BASE}/submariner-globalnet/service_account.yaml \
    ${RBAC_BASE}/submariner-globalnet/role.yaml \
    ${RBAC_BASE}/submariner-globalnet/role_binding.yaml \
    ${RBAC_BASE}/submariner-globalnet/cluster_role.yaml \
    ${RBAC_BASE}/submariner-globalnet/cluster_role_binding.yaml >> ${GLOBALNET_RBAC_YAML}
echo '{{- end -}}' >> ${GLOBALNET_RBAC_YAML}

# Generate the service discovery RBAC yaml for the operator chart
echo '{{- if .Values.submariner.serviceDiscovery }}' > ${SERVICE_DISC_RBAC_YAML}
add_service_acct_ns ${RBAC_BASE}/lighthouse-agent/cluster_role_binding.yaml
add_service_acct_ns ${RBAC_BASE}/lighthouse-coredns/cluster_role_binding.yaml
cat ${RBAC_BASE}/lighthouse-agent/service_account.yaml \
    ${RBAC_BASE}/lighthouse-agent/cluster_role.yaml \
    ${RBAC_BASE}/lighthouse-agent/cluster_role_binding.yaml \
    ${RBAC_BASE}/lighthouse-coredns/service_account.yaml \
    ${RBAC_BASE}/lighthouse-coredns/cluster_role.yaml \
    ${RBAC_BASE}/lighthouse-coredns/cluster_role_binding.yaml >> ${SERVICE_DISC_RBAC_YAML}
echo '{{- end -}}' >> ${SERVICE_DISC_RBAC_YAML}

# Generate the openshift monitoring rbac yaml for the operator chart
cat ${OPENSHIFT}/rbac/submariner-metrics-reader/role.yaml \
    ${OPENSHIFT}/rbac/submariner-metrics-reader/role_binding.yaml > ${OPENSHIFT_MONITORING_YAML}
