include:
  - essex.sqldata

glance:
  pkg: 
    - installed

glance-api:
  service:
    - running
    - watch:
      - file: /etc/glance/glance-api.conf
      - file: /etc/glance/glance-api-paste.ini
    - require:
      - pkg: glance

glance-registry:
  service:
    - running
    - watch:
      - file: /etc/glance/glance-registry.conf
      - file: /etc/glance/glance-registry-paste.ini
    - require:
      - pkg: glance

{% for i in ('api.conf','api-paste.ini','registry.conf','registry-paste.ini')%}
/etc/glance/glance-{{ i }}:
  file:
    - managed
    - source: salt://essex/glance-{{ i }}
    - require: 
      - pkg: glance
{% endfor %}

glance_db_sync:
  cmd:
    - wait
    - name: 'glance-manage version_control 0 && glance-manage db_sync'
    - watch:
      - file: /etc/glance/glance-registry.conf
    - require:
      - mysql_grants: mysql_glance
      - pkg: glance
