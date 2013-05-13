include:
  - essex.glance
  #- essex.nova

cirros_image:
  file:
    - managed
    - name: /usr/local/src/cirros-0.3.0-x86_64-disk.img
    - source: https://launchpad.net/cirros/trunk/0.3.0/+download/cirros-0.3.0-x86_64-disk.img
    - source_hash: md5=50bdc35edb03a38d91b1b071afb20a3c

glance_add_cirros:
  cmd:
    - run
    - name: OS_USERNAME={{ pillar['openstack']['OS_USERNAME'] }} OS_PASSWORD={{ pillar['openstack']['OS_PASSWORD'] }} SERVICE_TOKEN={{ pillar['openstack']['SERVICE_TOKEN'] }} OS_TENANT_NAME={{ pillar['openstack']['OS_TENANT_NAME'] }} OS_AUTH_URL={{ pillar['openstack']['OS_AUTH_URL'] }} SERVICE_ENDPOINT={{ pillar['openstack']['SERVICE_ENDPOINT'] }} OS_REGION_NAME={{ pillar['openstack']['OS_REGION_NAME'] }} glance index | grep -o cirros || OS_USERNAME={{ pillar['openstack']['OS_USERNAME'] }} OS_PASSWORD={{ pillar['openstack']['OS_PASSWORD'] }} SERVICE_TOKEN={{ pillar['openstack']['SERVICE_TOKEN'] }} OS_TENANT_NAME={{ pillar['openstack']['OS_TENANT_NAME'] }} OS_AUTH_URL={{ pillar['openstack']['OS_AUTH_URL'] }} SERVICE_ENDPOINT={{ pillar['openstack']['SERVICE_ENDPOINT'] }} OS_REGION_NAME={{ pillar['openstack']['OS_REGION_NAME'] }} glance add name=cirros disk_format=raw container_format=bare < /usr/local/src/cirros-0.3.0-x86_64-disk.img
    - require:
      - file: cirros_image
      - cmd: glance_db_sync
