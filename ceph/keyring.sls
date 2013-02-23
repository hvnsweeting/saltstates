
add-key:
    cmd.run:
        # separate two this command will cause error
        - name: 'eval $(ssh-agent) && yes | ssh-add /root/.ssh/id_rsa'

copy-key:
    cmd.run:
        - names:
        {% for h in pillar['all_ips'].split() %}
            - scp /etc/ceph/ceph.keyring {{ h }}:/etc/ceph/ceph.keyring
        {% endfor %}
        - require:
            - cmd: add-key
