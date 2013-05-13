include:
  - essex.sqldata
  - essex.keystone

glance:
  pkg:
    - installed

glance-services:
  service:
    - running
    - names:
      - glance-registry
      - glance-api
    - watch:
      - file: /etc/glance/glance-registry.conf
      - file: /etc/glance/glance-registry-paste.ini
      - file: /etc/glance/glance-api.conf
      - file: /etc/glance/glance-api-paste.ini
    - require:
      - pkg: glance

{% for i in ('api.conf','api-paste.ini','registry.conf','registry-paste.ini')%}
/etc/glance/glance-{{ i }}:
  file:
    - managed
    - source: salt://essex/glance-{{ i }}
    - require:
      - pkg: glance
    - required_in:
      - service: glance-services
{% endfor %}

glance_db_sync:
  cmd:
    - wait
    - name: 'glance-manage version_control 0 && glance-manage db_sync && service glance-api restart && service glance-registry restart'
    - require:
      - mysql_grants: mysql_glance
      - service: glance-services
      - cmd: ./sample_data.sh
    - watch:
      - pkg: glance
