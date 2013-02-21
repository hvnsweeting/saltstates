ceph-client:
    match: ubun3
    sls:
        - ceph.client

ceph-server:
    match: ubun2
    sls:
        - ceph.server

ceph-admin:
    match: ubun1
    sls:
        - ceph.admin
    require:
        - ceph-client
        - ceph-server
