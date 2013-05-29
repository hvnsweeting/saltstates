/etc/salt/minion:
  file:
    - managed
    - source: salt://salt/minion.jinja2
    - template: jinja

salt-minion:
  pkg:
    - installed
  service:
    - running
    - watch:
      - file: /etc/salt/minion
