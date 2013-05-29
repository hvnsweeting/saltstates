/etc/apt/apt.conf.d/02proxy:
  file:
    - managed
    - source: salt://apt-cacher/02proxy.jinja2
    - template: jinja
