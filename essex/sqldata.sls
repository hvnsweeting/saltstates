include:
  - mariadb

mysql_keystone:
  mysql_database:
    - present
    - name: keystone
    - require:
      - service: mariadb-server
  mysql_user:
    - present
    - password: openstack
    - name: keystone
    - require:
      - service: mariadb-server
  mysql_grants:
    - present
    - grant: all privileges
    - database: keystone.*
    - user: keystone
    - name: keystone
    - require:
      - service: mariadb-server

mysql_glance:
  mysql_database:
    - present
    - name: glance
    - require:
      - service: mariadb-server
  mysql_user:
    - present
    - password: openstack
    - name: glance
    - require:
      - service: mariadb-server

mysql_glance_grants:
  mysql_grants:
    - present
    - grant: all privileges
    - database: glance.*
    - user: glance
    - name: glance
    - require:
      - mysql_database: mysql_glance
      - mysql_user: mysql_glance
      - service: mariadb-server
