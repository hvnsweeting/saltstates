python-mysqldb:
  pkg:
    - installed

/var/lib/keystone/keystone.db:
  file:
    - absent
    #- if test -f /var/lib/keystone/keystone.db:
    #TODO add a if here


