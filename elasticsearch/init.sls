include:
  - java
{% set version = '0.20.6'%}
{% set checksum = 'md5=4dd464946a56525556c7810596bf970e' %}

/etc/default/elasticsearch:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://elasticsearch/default.jinja2
    - require:
      - pkg: elasticsearch

/etc/elasticsearch/logging.yml:
  file:
    - managed
    - template: jinja
    - user: elasticsearch
    - group: elasticsearch
    - mode: 440
    - source: salt://elasticsearch/logging.jinja2
    - require:
      - pkg: elasticsearch

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

elasticsearch:
  file.managed:
    - name: /usr/local/src/elasticsearch-{{ version }}.deb
    - source: http://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-{{ version }}.deb
    - source_hash: {{ checksum }}

  pkg.installed:
    - sources:
      - elasticsearch: /usr/local/src/elasticsearch-{{ version }}.deb
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
