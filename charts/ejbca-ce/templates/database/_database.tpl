{{/*
Common labels
*/}}
{{- define "ejbca-ce.database.labels" -}}
helm.sh/chart: {{ include "ejbca-ce.chart" . }}
{{include "ejbca-ce.database.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ejbca-ce.database.selectorLabels" -}}
app.kubernetes.io/name: {{ .Values.database.endpoint }}
{{- end }}