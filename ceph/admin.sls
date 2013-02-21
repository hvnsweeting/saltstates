#NOTE: this state will be run with overstate because deploycfg need to run after everything done
#salt-run state.over

include:
    - ceph.server

deploycfg:
    cmd.run:
        - name: 'mkcephfs -a -c /etc/ceph/ceph.conf -k /etc/ceph/ceph.keyring'
        - require:
            - pkg: ceph
            - file: /etc/ceph/ceph.conf
            - file: /var/lib/ceph

salt://ceph/copykeyring.sh:
    cmd:
        - script
        - require:
            - cmd: deploycfg
            - ssh_auth: sshkey

restart:
    cmd.run:
        - name: 'service ceph -a restart'
        - require:
            - pkg: ceph
            - cmd: deploycfg

ceph -s:
    cmd.run:
        - require:
            - cmd: restart
            - pkg: ceph
