# drop db
for i in `virsh list --all | grep instance | awk '{print $2}'`; do
    virsh destroy "$i"
    virsh undefine --managed-save "$i"
done

PASSWD=openstack
for u in 'keystone' 'glance' 'nova'; do
	mysql -u $u -p$PASSWD -e "drop database $u" $u
done

# remove soft
apt-get purge 'nova-*' glance-common keystone -y
set -x
rm -rf /var/lib/{nova,glance,keystone}
rm -rf /etc/{keystone,nova,glance}

set +x
