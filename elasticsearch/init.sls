java:
  pkg.installed:
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

  service.running:
    - enable: True
    - require:
      - pkg: elasticsearch
