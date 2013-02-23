include:
    - ceph.ceph

extend:
    ceph:
        service:
            - dead
            - watch:
                - file: /etc/ceph/ceph.conf

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
