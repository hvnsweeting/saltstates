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

      {#
{% for i in ('glance-' + s for s in ('api.conf','api-paste.ini','registry.conf','registry-paste.ini'))%}
{% endfor %}
      #}

/etc/glance/glance-api.conf:
  file:
    - managed
    - source: salt://essex/glance-api.conf
    - require: 
      - pkg: glance

/etc/glance/glance-api-paste.ini:
  file:
    - managed
    - source: salt://essex/glance-api-paste.ini
    - require: 
      - pkg: glance

/etc/glance/glance-registry.conf:
  file:
    - managed
    - source: salt://essex/glance-registry.conf
    - require: 
      - pkg: glance

/etc/glance/glance-registry-paste.ini:
  file:
    - managed
    - source: salt://essex/glance-registry-paste.ini
    - require: 
      - pkg: glance

glance_db_sync:
  cmd:
    - run
    - name: 'glance-manage version_control 0 && glance-manage db_sync'
    - require:
      - mysql_grants: mysql_glance_grants
