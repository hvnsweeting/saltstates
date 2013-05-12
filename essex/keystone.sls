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
    - enable: True
    - watch:
      - file: keystone
    - require:
      - pkg: keystone
  file:
    - managed
    - name: /etc/keystone/keystone.conf
    - source: salt://essex/keystone.conf.jinja2
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - required_in:
      - service: keystone
  cmd:
    - wait
    - name: 'keystone-manage db_sync'
    - watch:
      - pkg: keystone
    - require:
      - mysql_grants: mysql_keystone
      - service: keystone

/var/lib/keystone/keystone.db:
  file:
    - absent
    - require:
      - pkg: keystone

/usr/local/src/sample_data.sh:
  file:
    - managed
    - source: salt://essex/sample_data.sh
    - template: jinja
    - mode: 700

./sample_data.sh:
  cmd:
    - wait
    - cwd: /usr/local/src
    - watch:
      - cmd: keystone
    - require:
      - file: /usr/local/src/sample_data.sh
      - mysql_grants: mysql_keystone

