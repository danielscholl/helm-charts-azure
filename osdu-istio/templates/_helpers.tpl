{{- define "istio.cors.configuration" }}
{{- $corsorigins := .Values.global.cors.origins }}
{{- $corsmethods := .Values.global.cors.methods }}
{{- $corsallowedheaders := .Values.global.cors.allowedheaders }}
{{- $corsexposdedheaders := .Values.global.cors.exposedheaders }}
{{- $corsmaxage := print .Values.global.cors.maxage }}
{{- $corsallowCredentials := .Values.global.azure.allowCredentials | default true }}
{{- $istiocorsenabled := print .Values.global.azure.istioCorsEnabled | default "false" }}

{{- if eq $istiocorsenabled "true" }}
corsPolicy:
    allowHeaders:
    {{- range (split ";" $corsallowedheaders) }}
    - {{ . | quote }}
    {{- end }}
    allowMethods:
    {{- range (split ";" $corsmethods) }}
    - {{ . | quote }}
    {{- end }}
    allowOrigins:
    {{- range (split ";" $corsorigins) }}
    - exact: {{ . | quote }}
    {{- end }}
    exposeHeaders:
    {{- range (split ";" $corsexposdedheaders) }}
    - {{ . | quote }}
    {{- end }}
    maxAge: {{ duration $corsmaxage }}
    allowCredentials: {{ $corsallowCredentials }}
{{- end }}
{{- end }}