include:
    - websrv

extend:
    apache2:
        service:
            - watch:
                - file: /etc/apache2/conf.d/phpmyadmin.conf
    
phpmyadmin:
    pkg:
        - installed

/etc/apache2/conf.d/phpmyadmin.conf:
    file.symlink:
        - target: /etc/phpmyadmin/apache.conf
        - require:
                - pkg: phpmyadmin
                - pkg: apache2
