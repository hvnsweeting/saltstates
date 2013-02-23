#!/bin/bash

eval $(ssh-agent)
yes | ssh-add /root/.ssh/id_rsa
for h in {{ pillar['all_ips'] }}; do
    scp /etc/ceph/ceph.keyring $h:/etc/ceph/ceph.keyring
done
