include:
  - rabbitmq
  - essex.sqldata
  - essex.keystone

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
      - cmd: run_sync_nova
      - cmd: nova_network_and_inject_key
    - require:
      - pkg: nova
      - service: rabbitmq-server

/tmp/sync_nova.sh:
  file:
    - managed
    - source: salt://essex/sync_nova.sh
    - mode: 755

run_sync_nova:
  cmd:
    - wait
    - name: /tmp/sync_nova.sh
    - watch:
      - file: /etc/nova/nova.conf
    - require:
      - file: /tmp/sync_nova.sh
      - mysql_grants: mysql_nova
      - pkg: nova
      - cmd: ./sample_data.sh
      - service: nova-services

nova-services:
  service:
    - running
    - names:
{% for s in ("nova-compute", "nova-api", "nova-scheduler", "nova-volume", "nova-cert", "nova-consoleauth", "libvirt-bin") %}
      - {{ s }}
{% endfor %}
    - require:
      - pkg: nova
      - file: /etc/nova/api-paste.ini
      - file: /etc/nova/nova.conf

/etc/nova/api-paste.ini:
  file:
    - managed
    - source: salt://essex/api-paste.ini

/etc/nova/nova.conf:
  file:
    - managed
    - source: salt://essex/nova.conf
    - template: jinja

/tmp/id_rsa.pub:
  file:
    - managed
    - source: salt://essex/id_rsa.pub

nova_network_and_inject_key:
  cmd:
    - script
    - source: salt://essex/nova_sec.sh
    - template: jinja
    - require:
      - file: /tmp/id_rsa.pub
      - pkg: nova
      - cmd: run_sync_nova
      - service: nova-services
