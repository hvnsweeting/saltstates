debconf-utils:                 # ID declaration
    pkg:                  # state declaration
    - installed         # function declaration

mysql:
    pkg:
    - debconf: salt://debconf/mysql.ans
    - installed
    - names:
        - mysql-server
        - mysql-client
        - automysqlbackup
    - require: 
        - pkg: debconf-utils
