{{/*
Expand the name of the chart.
*/}}
{{- define "standard-ddms.name" -}}
{{- default .Release.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "standard-ddms.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "standard-ddms.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
DDMSs level labels
*/}}
{{- define "standard-ddms.common-labels" -}}
helm.sh/chart: {{ include "standard-ddms.chart" . }}
app.kubernetes.io/name: {{ include "standard-ddms.name" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
DDMSs services level labels
*/}}
{{- define "standard-ddms.service-labels" -}}
{{- $ := index . 0 }}
{{- with index . 1 }}
app: {{ .service }}
app.kubernetes.io/instance: {{ .service }}
{{ include "standard-ddms.common-labels" $ }}
{{- end }}
{{- end }}

{{/*
PODs selector labels
*/}}
{{- define "standard-ddms.selector-labels" -}}
{{- $ := index . 0 }}
{{- with index . 1 }}
app: {{ .service }}
app.kubernetes.io/instance: {{ .service }}
{{- end }}
{{- end }}