denyhosts:
   pkg:
    - installed

/etc/apt/apt.conf.d/02proxy:
    file.append:
        - text: 
            - Acquire::http { Proxy "http://10.0.0.12:3142"; };

unattended-upgrades:
    pkg:
        - installed
