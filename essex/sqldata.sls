hvndb:
  mysql_database:
    - present

keystone:
  mysql_database:
    - present
  mysql_user:
    - present
    - password: openstack
  mysql_grants:
    - present
    - grant: all privileges
    - database: keystone.*
    - user: keystone
