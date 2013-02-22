include:
    - apache2
    - proglang.php
    - db

git://github.com/Flyspray/flyspray.git:
    git.latest:
        - target: /var/www/flyspray
        - require:
            - pkg: apache2
            - pkg: php
            - pkg: mysql
