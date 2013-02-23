State for deploy ceph cluster
====================

admin.sls
--------
used for only 1 host that will do deploy (run mkcephfs)

server.sls
--------
for all server that run ceph's service (osd, mon, mds)

client.sls
--------
for clients 

usage
------
this state not provide a full automatically deploy yet, you should make sure
to do bellow steps:

    - create a ssh key (WITHOUT passphrase) for root user on admin host. Use its pubkey to replace pubkeys/cephadmin.pub
    - edit `ceph.conf` and `overstate.sls` to meet your need

