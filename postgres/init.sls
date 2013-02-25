include:
    - debconf-utils

postgres:
    pkg:
        - debconf: salt://postgres/postgres.sel
        - installed
        - name: postgresql-9.1
        - require:
            - pkg: debconf-utils
    
php5-pgsql:
    pkg:
        - installed
        - require:
            - pkg: postgres
