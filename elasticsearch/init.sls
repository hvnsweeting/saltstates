{% set version = '0.20.5'%}
{% set checksum = 'md5=e244c5a39515983ba81006a3186843f4' %}

/etc/default/elasticsearch:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://elasticsearch/default.jinja2
    - require:
      - pkg_file: elasticsearch

/etc/elasticsearch/logging.yml:
  file:
    - managed
    - template: jinja
    - user: elasticsearch
    - group: elasticsearch
    - mode: 440
    - source: salt://elasticsearch/logging.jinja2
    - require:
      - pkg_file: elasticsearch

/etc/elasticsearch/elasticsearch.yml:
  file:
    - managed
    - template: jinja
    - user: elasticsearch
    - group: elasticsearch
    - mode: 440
    - source: salt://elasticsearch/config.jinja2
    - context:
      http: 'true'
      master: 'true'
      data: 'true'
    - require:
      - pkg: elasticsearch

{% if grains['cpuarch'] == 'i686' %}
/usr/lib/jvm/java-7-openjdk:
  file:
    - symlink
    - target: /usr/lib/jvm/java-7-openjdk-i386
{% endif %}
jre7_headless:
  pkg:
    - latest
    - name: openjdk-7-jre-headless

elasticsearch:
  file.managed:
    - name: /usr/local/src/elasticsearch-{{ pillar['elasticsearch']['version'] }}.deb
    - source: http://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-{{ pillar['elasticsearch']['version'] }}.deb
    - source_hash: md5={{ pillar['elasticsearch']['md5'] }}

  pkg.installed:
    - sources:
      - elasticsearch: /usr/local/src/elasticsearch-{{ pillar['elasticsearch']['version'] }}.deb
    - require:
      - file: elasticsearch
  service:
    - running
    - enable: True
    - watch:
      - file: /etc/default/elasticsearch
      - file: /etc/elasticsearch/logging.yml
      - file: /etc/elasticsearch/elasticsearch.yml
      - pkg: jre7_headless
      - pkg: elasticsearch
{% if grains['cpuarch'] == 'i686' %}
      - file: /usr/lib/jvm/java-7-openjdk
{% endif %}
