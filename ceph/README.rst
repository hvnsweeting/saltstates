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
    - edit `ceph.conf` and `server.sls` for create appropriate directory (mds, mon, osd)
    - edit `copykeyring.sh`, add IP of all your server/client hosts
    - change `overstate.sls` to meet your need
