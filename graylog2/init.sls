{#
 State(s) common to graylog2 web and server
 #}

/var/log/graylog2:
  file:
    - directory
    - user: root
    - group: www-data
    - mode: 770
    - makedirs: True
