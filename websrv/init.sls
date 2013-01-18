apache2:                 # ID declaration
    pkg:                  # state declaration
    - installed         # function declaration
    service:
    - running
    - watch:
        - file: /etc/apache2/sites-available/default
        - file: /etc/apache2/conf.d/phpmyadmin.conf


/etc/apache2/sites-available/default:
    file:
        - managed
        - source: salt://config/dev.apa.conf
        - require: 
            - pkg: apache2

/var/www/index.php:
    file:
        - managed
        - source: salt://config/index.php
        - require:
             - pkg: apache2

/var/www/dev.vccloud.vn/:
    file.directory:
        - makedirs: True

{% for usr in 'hungnv','lamdt', 'hailt'  %}
/var/www/dev.vccloud.vn/{{ usr }}:
    file.symlink:
        - target: /home/{{ usr }}/dev/
{% endfor %}
