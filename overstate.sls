ceph-client:
    match: ubun3
    sls:
        - ceph.ceph

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
