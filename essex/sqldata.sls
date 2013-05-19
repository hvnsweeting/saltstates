include:
  - mariadb
  - python.mysqldb

{% for comp in ("keystone", "glance", "nova") %}
mysql_{{ comp }}:
  mysql_database:
    - present
    - name: {{ comp }}
    - require:
      - service: mariadb-server
      - pkg: python-mysqldb
  mysql_user:
    - present
    - password: openstack
    - name: {{ comp }}
    - require:
      - service: mariadb-server
      - pkg: python-mysqldb
  mysql_grants:
    - present
    - grant: all privileges
    - database: {{ comp }}.*
    - user: {{ comp }}
    - name: {{ comp }}
    - require:
      - pkg: python-mysqldb
      - service: mariadb-server
      - mysql_database: mysql_{{ comp }}
      - mysql_user: mysql_{{ comp }}
{% endfor %}
