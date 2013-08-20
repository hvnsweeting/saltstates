{%- set uid = salt['pillar.get']('uid', 'root') %}
/home/{{ uid }}/.emacs:
  file:
    - managed
    - source: salt://emacs/config.jinja2
    - template: jinja
    - user: {{ uid }}
