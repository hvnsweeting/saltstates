nova-compute:
  pkg:
    - installed
  service:
    - running
    - watch:
      - file: /etc/nova/nova.conf
      - file: /etc/nova/api-paste.ini
    - require:
      - pkg: nova-compute

/etc/nova/api-paste.ini:
  file:
    - managed
    - source: salt://essex/api-paste.ini
    - template: jinja

/etc/nova/nova.conf:
  file:
    - managed
    - source: salt://essex/nova.conf
    - template: jinja
