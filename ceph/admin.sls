#NOTE: this state will be run with overstate because deploycfg need to run after everything done
#salt-run state.over

include:
    - ceph.server

deploycfg:
    cmd.run:
        - name: 'cd /etc/ceph && mkcephfs -a -c /etc/ceph/ceph.conf -k ceph.keyring'
        - require:
            - pkg: ceph
            - file: /etc/ceph/ceph.conf
            - file: /var/lib/ceph

restart:
    cmd.run:
        - name: 'service ceph -a restart'
        - require:
            - cmd: deploycfg

ceph -s:
    cmd.run:
        - require:
            - cmd: restart
