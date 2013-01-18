base:
    '*':
        - core # git vim ccze
        - srvbase # base server : denyhosts, apt proxy

    'devserver.novalocal':
        - websrv 
        - db
        - proglang.python
        - proglang.php
        - phpmyadmin
        - user
