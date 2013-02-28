mongodeb:
  pkgrepo.managed:
    - name: deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen
    - keyid: 7F0CEB10
    - keyserver: keyserver.ubuntu.com

mongodb:
  pkg.installed:
    - name: mongodb-10gen
    - require:
      - pkgrepo: mongodeb

  service.running:
    - enable: True
    - require:
      - pkg: mongodb

  file.managed:
    - name: /etc/logrotate.d/mongodb
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://mongodb/logrotate.jinja2
