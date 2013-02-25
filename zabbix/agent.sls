zabbix-agent:
    pkg:
        - installed
    service:
        - running
        - watch:
            - file: /etc/zabbix/zabbix_agentd.conf

/etc/zabbix/zabbix_agentd.conf:
    file.managed:
        - template: jinja
        - source: salt://zabbix/zabbix_agentd.conf
