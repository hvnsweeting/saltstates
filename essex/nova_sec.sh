#!/bin/bash
export OS_USERNAME={{ pillar['openstack']['OS_USERNAME'] }}
export OS_PASSWORD={{ pillar['openstack']['OS_PASSWORD'] }}
export SERVICE_TOKEN={{ pillar['openstack']['SERVICE_TOKEN'] }}
export OS_TENANT_NAME={{ pillar['openstack']['OS_TENANT_NAME'] }}
export OS_AUTH_URL={{ pillar['openstack']['OS_AUTH_URL'] }}
export SERVICE_ENDPOINT={{ pillar['openstack']['SERVICE_ENDPOINT'] }}
export OS_REGION_NAME={{ pillar['openstack']['OS_REGION_NAME'] }}

nova secgroup-list-rules default | grep -q default || nova secgroup-add-rule default tcp 22 22 0.0.0.0/0
nova secgroup-list-rules default | grep tcp | grep -q 22 || nova secgroup-add-rule default icmp -1 -1 0.0.0.0/0
nova keypair-list | grep -q mykey || nova keypair-add --pub_key /tmp/id_rsa.pub mykey
