/etc/graylog2.conf:
  file.managed:
    - source: salt://graylog2/graylog2.jinja2
    - template: jinja

/etc/graylog2-elasticsearch.yml:
  file.managed:
    - source: salt://graylog2/elasticsearch.jinja2
    - template: jinja

graylog2-server_upstart:

graylog2-server_upstart:
  file.managed:
    - name: /etc/init/graylog2-server.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - source: salt://graylog2/upstart.jinja2

tarball:
  file.managed:
    - name: /usr/local/src/graylog2-server-{{ pillar['graylog2']['server']['version']}}.tar.gz
    - source: http://download.graylog2.org/graylog2-server/graylog2-server-{{ pillar['graylog2']['server']['version']}}.tar.gz
    - source_hash: md5={{ pillar['graylog2']['server']['md5']}}

untar:
  cmd.run:
    - cwd: /usr/local
    - name: tar xzf src/graylog2-server-{{ pillar['graylog2']['server']['version']}}.tar.gz --no-same-owner
    - require: 
      - file: tarball
    - unless: test -d /usr/local/graylog2-server-{{ pillar['graylog2']['server']['version']}}/
    
graylog2-server:
  pkg:
    - latest
    - name: openjdk-7-jre-headless
  service:
    - running
    - enable: True
    - watch:
      - file: graylog2-server_upstart
      - pkg: graylog2-server
      - file: tarball
      - cmd: untar
    - require:
      - file: /var/log/graylog2

/var/log/graylog2:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 750
