include: 
  - essex.sqldata
  - python.mysqldb

keystone:
  pkg:
    - installed
    - require:
      - pkg: python-mysqldb
  service:
    - running
    - enable: False
    - watch:
      - file: keystone
  file:
    - managed
    - name: /etc/keystone/keystone.conf
    - source: salt://essex/keystone.conf.jinja2
    - template: jinja
    - mode: 644
    - user: root
    - group: root
  cmd:
    - wait
    - name: 'keystone-manage db_sync'
    - watch:
      - pkg: keystone
    - require: 
      - file: keystone
      - mysql_grants: mysql_keystone

/var/lib/keystone/keystone.db:
  file:
    - absent
    - require: 
      - pkg: keystone

sample_data.sh:
  cmd:
    - script
    - source: salt://essex/sample_data.sh
    - require:
      - cmd: keystone
