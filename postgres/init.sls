postgres:
    pkg.installed:
        - name: postgresql-9.1
    
php5-pgsql:
    pkg:
        - installed
        - require:
            - pkg: postgres
