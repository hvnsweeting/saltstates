/etc/apt/sources.list.d/ceph.list:
    file.managed:
        - source: salt://ceph/apt.list
        - template: jinja
        - require:
            - cmd: repo-key

repo-key:
    cmd.run:
        - name: 'wget -q -O- "https://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc" | sudo apt-key add -'
        - unless: 'apt-key list | grep -q -i ceph' 

ceph:
    pkg:
        - installed
        - require:
            - cmd: repo-key

sshkey:
    ssh_auth:
        - present
        - user: root
        # ssh-pubkey you will need to access to all servers/clients
        - source: salt://ceph/cephadmin.pub


/etc/ceph/ceph.conf:
    file.managed:
        - source: salt://ceph/ceph.conf
        - template: jinja
        - require:
            - pkg: ceph
