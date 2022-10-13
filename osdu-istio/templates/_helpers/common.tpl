{{- define "job.annotations" }}
helm.sh/hook: post-install,post-upgrade
helm.sh/hook-weight: "1"
helm.sh/hook-delete-policy: before-hook-creation
{{- end }}
{{- define "postOperator.annotations" }}
helm.sh/hook: post-install,post-upgrade
helm.sh/hook-weight: "0"
helm.sh/hook-delete-policy: before-hook-creation
helm.sh/resource-policy: keep
{{- end }}

{{/*
Construct the name of the certificate name.
*/}}
{{- define "secret.certName" -}}
{{- if eq ( .Values.global.istio.enableIstioKeyvaultCert | quote ) "true" -}}
{{- printf "appgw-ssl-cert" -}}
{{- else -}}
{{- printf "osdu-istio-certificate" -}}
{{- end -}}
{{- end -}}

{{- define "secret.istioKeyvaultCert" -}}
{{- if eq ( .Values.global.istio.enableIstioKeyvaultCert | quote ) "true" -}}
{{- true -}}
{{- end -}}
{{- end -}}
