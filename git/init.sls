{%- macro pillar(sls) %}
{{ salt['pillar.get'](sls, True) }}
{%- endmacro %}

include:
  - git.base
{%- if pillar('config') %}
  - git.config
{%- endif %}
{%- if pillar('user') %}
  - git.user
{%- endif %}
{%- if pillar('github') %}
  - git.github
{%- endif %}
