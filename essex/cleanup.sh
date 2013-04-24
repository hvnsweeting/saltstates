# drop db
PASSWD=openstack
for u in 'keystone' 'glance'; do
	mysql -u $u -p$PASSWD -e "drop database $u" $u
done

# remove soft
apt-get purge keystone -y
rm -rf /etc/keystone/
