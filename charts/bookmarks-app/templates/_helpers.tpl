{{/*
Expand the name of the chart.
*/}}
{{- define "bookmarks-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "bookmarks-app.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := include "bookmarks-app.name" . -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Chart name and version for labels.
*/}}
{{- define "bookmarks-app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels.
*/}}
{{- define "bookmarks-app.labels" -}}
helm.sh/chart: {{ include "bookmarks-app.chart" . }}
{{ include "bookmarks-app.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels for the default chart workload.
Use component-specific selectors for frontend/backend instead.
*/}}
{{- define "bookmarks-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "bookmarks-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Frontend naming.
*/}}
{{- define "bookmarks-app.frontendFullname" -}}
{{- printf "%s-frontend" (include "bookmarks-app.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "bookmarks-app.frontendLabels" -}}
{{ include "bookmarks-app.labels" . }}
app.kubernetes.io/component: frontend
{{- end -}}

{{- define "bookmarks-app.frontendSelectorLabels" -}}
app.kubernetes.io/name: {{ include "bookmarks-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: frontend
{{- end -}}

{{/*
Backend naming.
*/}}
{{- define "bookmarks-app.backendFullname" -}}
{{- printf "%s-backend" (include "bookmarks-app.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "bookmarks-app.backendLabels" -}}
{{ include "bookmarks-app.labels" . }}
app.kubernetes.io/component: backend
{{- end -}}

{{- define "bookmarks-app.backendSelectorLabels" -}}
app.kubernetes.io/name: {{ include "bookmarks-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: backend
{{- end -}}

{{/*
Service account name.
If serviceAccount.create is false, use the provided name or default to "default".
*/}}
{{- define "bookmarks-app.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{- default (include "bookmarks-app.fullname" .) .Values.serviceAccount.name -}}
{{- else -}}
{{- default "default" .Values.serviceAccount.name -}}
{{- end -}}
{{- end -}}
