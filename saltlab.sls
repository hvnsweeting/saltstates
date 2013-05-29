{# This state is only for me, others should not use it #}
include:
  - apt-cacher.client
  - core
{# TODO vim-salt, autoconfig git, vim rc #}

{% set user = "hvn" %}

/srv/salt/hvn:
  file:
    - symlink
    - target: /home/{{ user }}/saltstates
    - makedirs: True

/srv/salt/bfs:
  file:
    - symlink
    - target: /home/{{ user }}/salt-common
    - makedirs: True
