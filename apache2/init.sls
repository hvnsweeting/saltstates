apache2:
    pkg:
        - installed
    service:
        - running

for-php:
    pkg.installed:
        - name: libapache2-mod-php5
        - require:
            - pkg: apache2
