PASSWD=hehehe
HOST=localhost
DBPASS=openstack
for dbname in nova glance cinder keystone ovs_quantum;do
    mysql -u root -p$PASSWD -e "create database $dbname;"
    mysql -u root -p$PASSWD -e "drop user $dbname@'%';"
    mysql -u root -p$PASSWD -e "drop user $dbname@'$HOST';"
done


mysql -u root -p$PASSWD << EOC
grant all privileges on nova.* to nova@"$HOST" identified by "$DBPASS";
grant all privileges on nova.* to nova@"%" identified by "$DBPASS";
grant all privileges on glance.* to glance@"$HOST" identified by "$DBPASS";
grant all privileges on glance.* to glance@"%" identified by "$DBPASS";
grant all privileges on cinder.* to cinder@"$HOST" identified by "$DBPASS";
grant all privileges on cinder.* to cinder@"%" identified by "$DBPASS";
grant all privileges on keystone.* to keystone@"$HOST" identified by "$DBPASS";
grant all privileges on keystone.* to keystone@"%" identified by "$DBPASS";
grant all privileges on ovs_quantum.* to ovs_quantum@"$HOST" identified by "$DBPASS";
grant all privileges on ovs_quantum.* to ovs_quantum@"%" identified by "$DBPASS";
EOC
