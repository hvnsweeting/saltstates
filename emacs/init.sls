{%- macro pillar(sls) %}
{{ salt['pillar.get'](sls, True) }}
{%- endmacro %}

include:
  - emacs.base
{%- if pillar('config') %}
  - emacs.config
{%- endif %}
