mariadb_repo:
  pkgrepo:
    - managed
    - keyid: '0xcbcb082a1bb943db'
    - keyserver: keyserver.ubuntu.com
    - name: deb http://repo.maxindo.net.id/mariadb/repo/5.5/ubuntu precise main

{# Use your own files from running mysql/mariadb server. 
   It help skipping interactive for entering root's password #}
/etc/mysql/debian.cnf:
  file:
    - managed
    - source: salt://mariadb/debian.cnf
    - mode: 600
    - makedirs: True

/etc/mysql/my.cnf:
  file:
    - managed
    - source: salt://mariadb/my.cnf.jinja2
    - mode: 644
    - makedirs: True

mariadb-server:
  pkg:
    - installed
    - require:
      - pkgrepo: mariadb_repo
      - file: /etc/mysql/debian.cnf
      - file: /etc/mysql/my.cnf
  service:
    - name: mysql
    - running
    - enable: False
    - watch:
      - file: /etc/mysql/my.cnf
      - file: /etc/mysql/debian.cnf
    - require:
      - pkg: mariadb-server
