mysql:
    pkg:
    - debconf: salt://mysql/mysql.sel
    - installed
    - names:
        - mysql-server
        - mysql-client
        - automysqlbackup
