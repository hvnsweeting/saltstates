salt://rethinkdb/add.sh:
    cmd:
        - script

rethinkdb:
    pkg:
        - installed

py-rethinkdb:
    pip:
        - installed
        - name: rethinkdb
