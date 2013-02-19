# for ceph client
include:
    - ceph.ceph

/etc/ceph/ceph.conf:
    file.managed:
        - source: salt://ceph/ceph.conf
        - template: jinja
