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
      - cmd: nova-manage db sync
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
      - cmd: ./sample_data.sh

nova-services:
  service:
    - running
    - names:
{% for s in ("nova-compute", "nova-api", "nova-scheduler", "nova-volume", "nova-cert", "nova-consoleauth", "libvirt-bin") %}
      - {{ s }}
{% endfor %}
    - require:
      - pkg: nova
    - watch:
      - cmd: nova-manage db sync
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

nova_allow_access_and_inject_key:
  cmd:
    - script
    - source: salt://essex/nova_sec.sh
    - template: jinja
    - require:
      - file: /tmp/id_rsa.pub
      - pkg: nova
      - cmd: nova-manage db sync
      - service: nova-services
