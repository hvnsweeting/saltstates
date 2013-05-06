admin_token: ADMINTOKEN
nova:
  address: {{ salt['network.ip_addrs']()[-1] }}
  network_range: 192.168.100.0/24
