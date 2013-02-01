keystone:
    pkg:
        - installed

glance:
    pkg: 
        - installed

nova:
    pkg:
        - installed
        - names: 
            - nova-compute
            - nova-network

glance-api:
    service:
        - running
    watch:
        - file: /etc/glance/glance-api.conf
        - file: /etc/glance/glance-api-paste.ini
    require:
        - pkg: glance

glance-registry:
    service:
        - running
    watch:
        - file: /etc/glance/glance-registry.conf
        - file: /etc/glance/glance-registry-paste.ini
    require:
        - pkg: glance

nova-network:
    service:
        - running
    watch:
        - file: /etc/nova/nova.conf
    require:
        - pkg: nova

/etc/glance/glance-api.conf:
    file:
        - managed
        - source: salt://essex/glance-api.conf

/etc/glance/glance-api-paste.ini:
    file:
        - managed
        - source: salt://essex/glance-api-paste.ini

/etc/glance/glance-registry.conf:
    file:
        - managed
        - source: salt://essex/glance-registry.conf

/etc/glance/glance-registry-paste.ini:
    file:
        - managed
        - source: salt://essex/glance-registry-paste.ini

/etc/nova/api-paste.ini:
    file:
        - managed
        - source: salt://essex/api-paste.ini

/etc/nova/nova.conf:
    file:
        - managed
        - source: salt://essex/nova.conf

/tmp/sample_data.sh:
    file:
        - managed
        - source: salt://openstack/sample_data.sh
        - user: root 
        - group: root
        - mode: 744
    cmd:
        - run
        - require:
            - file: /tmp/sample_data.sh

