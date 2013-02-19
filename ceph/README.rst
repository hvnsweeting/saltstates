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

TODO: copy keyring to all client, server
