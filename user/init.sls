{% for usr in 'hungnv','hailt','lamdt' %}
{{ usr }}:
    user:
        - present
        - shell: /bin/bash
    ssh_auth:
        - present
        - user: {{ usr }} 
        - enc: ssh-rsa
        - source: salt://keys/{{ usr }}.pub
{% endfor %}
