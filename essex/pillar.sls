openstack:
  OS_USERNAME: admin
  OS_PASSWORD: secrete
  SERVICE_TOKEN: ADMINTOKEN
  OS_TENANT_NAME: admin
  OS_AUTH_URL: http://127.0.0.1:5000/v2.0/
  SERVICE_ENDPOINT: http://127.0.0.1:35357/v2.0
  OS_REGION_NAME: RegionOne

nova:
  address: {{ salt['network.ip_addrs']()[-1] }}
  network_range: 192.168.100.0/24
