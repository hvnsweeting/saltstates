#!/bin/bash

eval $(ssh-agent)
yes | ssh-add /root/.ssh/id_rsa
for h in 192.168.122.213; do
    scp /etc/ceph/ceph.keyring $h:/etc/ceph/ceph.keyring
done
