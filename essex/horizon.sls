memcached:
  pkg:
    - installed
  service:
    - running

openstack-dashboard:
  pkg:
    - installed
    - require:
      - pkg: memcached
