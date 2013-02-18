include:
    - ceph.ceph

extend:
    ceph:
        service:
            - dead
            - watch:
                - file: /etc/ceph/ceph.conf

/etc/ceph/ceph.conf:
    file.managed:
        - source: salt://ceph/ceph.conf
        - template: jinja

deploycfg:
    cmd:
        - script
        - source: salt://ceph/deploycfg.sh
        - require:
            - pkg: ceph
