{# This state is only for me, others should not use it #}
include:
  - apt-cacher.client
  - core
  - salt.minion
{# TODO vim-salt, autoconfig git, vim rc #}

{% set user = "hvn" %}
{# not tested #}
salt_dir_create:
  cmd:
    - run
    - name: mv /srv/salt /srv/salt.old && mkdir /srv/salt
    - only_if: test -L /srv/salt

/srv/salt/hvn:
  file:
    - symlink
    - target: /home/{{ user }}/saltstates
    - makedirs: True
    - require:
      - cmd: salt_dir_create

/srv/salt/bfs:
  file:
    - symlink
    - target: /home/{{ user }}/salt-common
    - makedirs: True
    - require:
      - cmd: salt_dir_create

/srv/salt/top.sls:
  file:
    - managed
    - source: salt://salt/top.sls
