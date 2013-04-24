hvndb:
  mysql_database:
    - present

mysql_keystone:
  mysql_database:
    - present
    - name: keystone
  mysql_user:
    - present
    - password: openstack
    - name: keystone
  mysql_grants:
    - present
    - grant: all privileges
    - database: keystone.*
    - user: keystone
    - name: keystone

mysql_glance:
  mysql_database:
    - present
    - name: glance
  mysql_user:
    - present
    - password: openstack
    - name: glance

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
