{{/*
Expand the name of the chart.
*/}}
{{- define "ejbca-ce.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ejbca-ce.fullname" -}}
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
{{- define "ejbca-ce.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "ejbca-ce.labels" -}}
helm.sh/chart: {{ include "ejbca-ce.chart" . }}
{{ include "ejbca-ce.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ejbca-ce.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ejbca-ce.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "ejbca-ce.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "ejbca-ce.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- /*
this will take the databse values and convert to the jdbcUrl format
*/}}
{{- define "ejbca-ce.util.format.jdbcUrl" -}}
{{- $ := index . 0 }}
{{- $type := $.Values.database.type -}}
{{- $properties := $.Values.database.properties -}}
{{- $host := $.Values.database.host -}}
{{- $port := $.Values.database.port | int -}}
{{- $name := $.Values.database.name -}}
{{- if eq $type "postgresql" -}}
{{- printf "jdbc:postgresql://%s:%d/%s%s" $host $port $name $properties }}
{{- else if eq $type "mariadb" -}}
{{- printf "jdbc:mysql://%s:%d/%s%s" $host $port $name $properties }}
{{- end -}}
{{- end -}}
