#!/bin/bash

set -e

BROKER_ROLE_TPL=submariner-k8s-broker/templates/_role.tpl
OPERATOR_RBAC_YAML=submariner-operator/templates/operator-rbac.yaml
GATEWAY_RBAC_YAML=submariner-operator/templates/gateway-rbac.yaml
ROUTE_AGENT_RBAC_YAML=submariner-operator/templates/routeagent-rbac.yaml
GLOBALNET_RBAC_YAML=submariner-operator/templates/globalnet-rbac.yaml
SERVICE_DISC_RBAC_YAML=submariner-operator/templates/service-discovery-rbac.yaml
OPENSHIFT_MONITORING_YAML=submariner-operator/templates/openshift-monitoring-rbac.yaml

function add_service_acct_ns() {
    sed -i '/- kind: ServiceAccount/a \ \ \ \ namespace: {{ .Release.Namespace }}' $1
}

mkdir -p yamls
cd yamls
curl -L https://raw.githubusercontent.com/submariner-io/submariner-operator/refs/heads/$1/pkg/embeddedyamls/yamls.go | ../extract-yamls
cd -

# Generate the CRDs for the broker chart
mkdir -p submariner-k8s-broker/crds
cat yamls/Deploy_submariner_crds_submariner_io_endpoints.yaml \
	  yamls/Deploy_submariner_crds_submariner_io_clusters.yaml \
		yamls/Deploy_submariner_crds_submariner_io_gateways.yaml \
		yamls/Deploy_mcsapi_crds_multicluster_x_k8s_io_serviceexports.yaml \
		yamls/Deploy_mcsapi_crds_multicluster_x_k8s_io_serviceimports.yaml > submariner-k8s-broker/crds/crd.yaml

# Generate the client role yaml for the broker chart
echo '{{- define "broker-role" -}}' > ${BROKER_ROLE_TPL}
cat yamls/Config_broker_broker_client_role.yaml >> ${BROKER_ROLE_TPL}
echo '{{- end -}}' >> ${BROKER_ROLE_TPL}
sed -i -e 's/name:.*/name: {{ template "submariner-k8s-broker.fullname" \. }}-cluster/' ${BROKER_ROLE_TPL}

# Generate the CRDs for the operator chart
mkdir -p submariner-operator/crds
cat yamls/Deploy_crds_submariner_io_submariners.yaml \
    yamls/Deploy_crds_submariner_io_servicediscoveries.yaml \
    yamls/Deploy_crds_submariner_io_brokers.yaml > submariner-operator/crds/crd.yaml

# Generate the operator RBAC yaml for the operator chart
echo '{{- if .Values.rbac.create -}}' > ${OPERATOR_RBAC_YAML}
add_service_acct_ns yamls/Config_rbac_submariner_operator_cluster_role_binding.yaml
cat yamls/Config_rbac_submariner_operator_service_account.yaml \
    yamls/Config_rbac_submariner_operator_role.yaml \
    yamls/Config_rbac_submariner_operator_role_binding.yaml \
    yamls/Config_rbac_submariner_operator_cluster_role.yaml \
    yamls/Config_rbac_submariner_operator_cluster_role_binding.yaml > ${OPERATOR_RBAC_YAML}
echo '{{- end -}}' >> ${OPERATOR_RBAC_YAML}

# Generate the gateway RBAC yaml for the operator chart
echo '{{- if .Values.rbac.create -}}' > ${GATEWAY_RBAC_YAML}
add_service_acct_ns yamls/Config_rbac_submariner_gateway_cluster_role_binding.yaml
cat yamls/Config_rbac_submariner_gateway_service_account.yaml \
    yamls/Config_rbac_submariner_gateway_role.yaml \
    yamls/Config_rbac_submariner_gateway_role_binding.yaml \
    yamls/Config_rbac_submariner_gateway_cluster_role.yaml \
    yamls/Config_rbac_submariner_gateway_cluster_role_binding.yaml > ${GATEWAY_RBAC_YAML}
echo '{{- end -}}' >> ${GATEWAY_RBAC_YAML}

# Generate the routeagent RBAC yaml for the operator chart
echo '{{- if .Values.rbac.create -}}' > ${ROUTE_AGENT_RBAC_YAML}
add_service_acct_ns yamls/Config_rbac_submariner_route_agent_cluster_role_binding.yaml
cat yamls/Config_rbac_submariner_route_agent_service_account.yaml \
    yamls/Config_rbac_submariner_route_agent_role.yaml \
    yamls/Config_rbac_submariner_route_agent_role_binding.yaml \
    yamls/Config_rbac_submariner_route_agent_cluster_role.yaml \
    yamls/Config_rbac_submariner_route_agent_cluster_role_binding.yaml > ${ROUTE_AGENT_RBAC_YAML}
echo '{{- end -}}' >> ${ROUTE_AGENT_RBAC_YAML}

# Generate the globalnet RBAC yaml for the operator chart
echo '{{- if .Values.rbac.create -}}' > ${GLOBALNET_RBAC_YAML}
echo '{{- if .Values.broker.globalnet }}' > ${GLOBALNET_RBAC_YAML}
add_service_acct_ns yamls/Config_rbac_submariner_globalnet_cluster_role_binding.yaml
cat yamls/Config_rbac_submariner_globalnet_service_account.yaml \
    yamls/Config_rbac_submariner_globalnet_role.yaml \
    yamls/Config_rbac_submariner_globalnet_role_binding.yaml \
    yamls/Config_rbac_submariner_globalnet_cluster_role.yaml \
    yamls/Config_rbac_submariner_globalnet_cluster_role_binding.yaml >> ${GLOBALNET_RBAC_YAML}
echo '{{- end -}}' >> ${GLOBALNET_RBAC_YAML}

# Generate the service discovery RBAC yaml for the operator chart
echo '{{- if .Values.rbac.create -}}' > ${SERVICE_DISC_RBAC_YAML}
echo '{{- if .Values.submariner.serviceDiscovery }}' > ${SERVICE_DISC_RBAC_YAML}
add_service_acct_ns yamls/Config_rbac_lighthouse_agent_cluster_role_binding.yaml
add_service_acct_ns yamls/Config_rbac_lighthouse_coredns_cluster_role_binding.yaml
cat yamls/Config_rbac_lighthouse_agent_service_account.yaml \
    yamls/Config_rbac_lighthouse_agent_cluster_role.yaml \
    yamls/Config_rbac_lighthouse_agent_cluster_role_binding.yaml \
    yamls/Config_rbac_lighthouse_coredns_service_account.yaml \
    yamls/Config_rbac_lighthouse_coredns_cluster_role.yaml \
    yamls/Config_rbac_lighthouse_coredns_cluster_role_binding.yaml >> ${SERVICE_DISC_RBAC_YAML}
echo '{{- end -}}' >> ${SERVICE_DISC_RBAC_YAML}

# Generate the openshift monitoring rbac yaml for the operator chart
echo '{{- if .Values.rbac.create -}}' > ${OPENSHIFT_MONITORING_YAML}
cat yamls/Config_openshift_rbac_submariner_metrics_reader_role.yaml \
    yamls/Config_openshift_rbac_submariner_metrics_reader_role_binding.yaml >> ${OPENSHIFT_MONITORING_YAML}
echo '{{- end -}}' >> ${OPENSHIFT_MONITORING_YAML}
