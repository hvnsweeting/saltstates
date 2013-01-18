phpmyadmin:
    pkg:
        - installed

/etc/apache2/conf.d/phpmyadmin.conf:
    file.symlink:
        - target: /etc/phpmyadmin/apache.conf
        - require:
                - pkg: phpmyadmin
                - pkg: apache2
