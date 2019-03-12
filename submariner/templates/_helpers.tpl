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
Create the name of the submariner-engine service account to use
*/}}
{{- define "submariner.engineServiceAccountName" -}}
{{- if .Values.serviceAccounts.engine.create -}}
    {{ default (printf "%s-engine" (include "submariner.fullname" .)) .Values.serviceAccounts.engine.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccounts.engine.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the submariner-route-agent service account to use
*/}}
{{- define "submariner.routeAgentServiceAccountName" -}}
{{- if .Values.serviceAccounts.routeAgent.create -}}
    {{ default (printf "%s-routeagent" (include "submariner.fullname" .)) .Values.serviceAccounts.routeAgent.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccounts.routeAgent.name }}
{{- end -}}
{{- end -}}