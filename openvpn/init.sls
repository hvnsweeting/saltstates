openvpn:
  pkg:
    - installed
  service:
    - running
    - watch:
{% for file in salt['pillar.get']('openvpn:pki_files') %}
      - file: /etc/openvpn/{{ file }}
{% endfor %}

{% for file in salt['pillar.get']('openvpn:pki_files') %}
/etc/openvpn/{{ file }}:
  file.managed:
    - source: salt://openvpn/{{ file }}
    - makedirs: True
    - mode: 644
    - user: root
    - group: root
{% endfor %}
