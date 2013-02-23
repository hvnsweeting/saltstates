# /srv/pillar/ceph.sls
mon_a_host: ubun1
mon_a_addr: 192.168.122.30

osd_0_host: ubun1
osd_1_host: ubun2

# do not include ip of admin host
all_ips: 192.168.122.250 192.168.122.213
