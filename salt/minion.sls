/etc/salt/minion:
  file:
    - managed
    - source: salt://salt/minion.jinja2
    - mode: 644
    - uid: root
    - gid: root

salt-minion:
  pkg:
    - installed
  service:
    - running
    - watch:
      - file: /etc/salt/minion
