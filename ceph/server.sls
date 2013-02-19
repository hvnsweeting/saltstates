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

/var/lib/ceph:
    file.directory:
        #TODO this create redundant directory, need a better way
        - names:
             {% for dir in 'osd.0','osd.1','mds.a' %}
               - /var/lib/ceph/{{ dir.split('.')[0] }}/ceph-{{ dir.split('.')[1] }}
              {% endfor %}
        - makedirs: True
        - require:
            - pkg: ceph

sshkey:
    ssh_auth:
        - present
        - user: root
        # ssh-pubkey you will need to access to all servers
        - source: salt://pubkeys/hvnatu1210.pub
