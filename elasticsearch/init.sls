java:
  pkg.installed:
    - name:
    openjdk-7-jre-headless 

elasticsearch:
  file.managed:
    - name: /usr/local/src/elasticsearch-0.20.5.deb
    - source: http://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.20.5.deb
    - source_hash: md5=e244c5a39515983ba81006a3186843f4

  pkg.installed:
    - sources:
      - elasticsearch: /usr/local/src/elasticsearch-0.20.5.deb
    - require:
      - file: elasticsearch
  service.running:
    - enable: True
    - require:
      - pkg: elasticsearch
