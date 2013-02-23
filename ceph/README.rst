State for deploy ceph cluster
====================

admin.sls
--------
used for only 1 host that will do deploy (run mkcephfs)

server.sls
--------
for all servers that run ceph's service (osd, mon, mds)

ceph.sls
--------
for clients , base for others

usage
------
this state not provide a full automatically deploy yet, you should make sure
to do bellow steps:

    - create a ssh key pair (WITHOUT passphrase). Replace id_rsa, cephadmin.key with your new private and public key arcordingly
    - edit `ceph.pillar.sls`, change ip and hostname according to your cluster
    - edit `server.sls` to create appropriate directory (mds, mon, osd)
    - change `overstate.sls` to meet your need
