include:
  - rabbitmq
  - essex.sqldata

nova:
  pkg:
    - installed
    - pkgs: 
      - nova-compute
      - nova-network
      - nova-api
      - nova-cert 
      - nova-compute-qemu
      - nova-doc 
      - nova-network
      - nova-objectstore
      - nova-scheduler 
      - nova-volume
      - novnc
      - nova-consoleauth

nova-network:
  service:
    - running
    - watch:
      - file: /etc/nova/nova.conf
    - require:
      - pkg: nova
      - service: rabbitmq-server

nova-manage db sync:
  cmd:
    - wait
    - watch:
      - file: /etc/nova/nova.conf
    - require:
      - mysql_grants: mysql_nova
      - pkg: nova

{% for s in ("nova-compute", "nova-api", "nova-scheduler", "nova-volume", "nova-cert", "nova-consoleauth") %}
{{ s }}:
  service:
    - running
    - enable: False
    - require:
      - pkg: nova
{% endfor %}
#nova-objectstore 

/etc/nova/api-paste.ini:
  file:
    - managed
    - source: salt://essex/api-paste.ini

/etc/nova/nova.conf:
  file:
    - managed
    - source: salt://essex/nova.conf
    - template: jinja
