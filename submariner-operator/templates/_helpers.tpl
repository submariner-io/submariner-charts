{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "submariner.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "submariner.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "submariner.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the submariner-operator service account to use
*/}}
{{- define "submariner.operatorServiceAccountName" -}}
{{- if .Values.serviceAccounts.operator.create -}}
    {{ default (printf "%s" (include "submariner.fullname" .)) .Values.serviceAccounts.operator.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccounts.operator.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the submariner-gateway service account to use
*/}}
{{- define "submariner.gatewayServiceAccountName" -}}
{{- if .Values.serviceAccounts.gateway.create -}}
    {{ default "submariner-gateway" .Values.serviceAccounts.gateway.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccounts.gateway.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the submariner-route-agent service account to use
*/}}
{{- define "submariner.routeAgentServiceAccountName" -}}
{{- if .Values.serviceAccounts.routeAgent.create -}}
    {{ default "submariner-routeagent" .Values.serviceAccounts.routeAgent.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccounts.routeAgent.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the submariner-globalnet service account to use
*/}}
{{- define "submariner.globalnetServiceAccountName" -}}
{{- if .Values.serviceAccounts.globalnet.create -}}
    {{ default "submariner-globalnet" .Values.serviceAccounts.globalnet.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccounts.globalnet.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the submariner-lighthouse-agent service account to use
*/}}
{{- define "submariner.lighthouseAgentServiceAccountName" -}}
{{- if and (.Values.submariner.serviceDiscovery ) (.Values.serviceAccounts.lighthouseAgent.create) -}}
    {{ default "submariner-lighthouse-agent" .Values.serviceAccounts.lighthouseAgent.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccounts.lighthouseAgent.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the submariner-lighthouse-coredns service account to use
*/}}
{{- define "submariner.lighthouseCoreDnsServiceAccountName" -}}
{{- if and (.Values.submariner.serviceDiscovery ) (.Values.serviceAccounts.lighthouseCoreDns.create) -}}
    {{ default "submariner-lighthouse-coredns" .Values.serviceAccounts.lighthouseCoreDns.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccounts.lighthouseCoreDns.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the submariner-lighthouse-coredns service name to use
*/}}
{{- define "submariner.lighthouseDnsName" -}}
{{- default (printf "%s-lighthouse-coredns" (include "submariner.fullname" .)) .Values.lighthouseCoredns.name }}
{{- end -}}
