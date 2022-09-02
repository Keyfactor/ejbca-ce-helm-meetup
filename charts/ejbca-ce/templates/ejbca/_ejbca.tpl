{{/*
Common labels
*/}}
{{- define "ejbca-ce.ejbca.labels" -}}
helm.sh/chart: {{ include "ejbca-ce.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ejbca-ce.rr.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ejbca-ce.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
rrRoute: {{ .Values.ejbca.rr.name }}
{{- end }}

{{- define "ejbca-ce.ui.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ejbca-ce.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
uiRoute: {{ .Values.ejbca.ui.name }}
{{- end }}

{{- define "ejbca-ce.lb.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ejbca-ce.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
lbRoute: {{ .Values.ejbca.lb.name }}
{{- end }}