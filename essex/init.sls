keystone:
    pkg:
        - installed

glance:
    pkg: 
        - installed


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
