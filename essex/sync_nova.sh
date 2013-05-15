#!/bin/bash

for i in nova-api nova-compute nova-network nova-scheduler novnc nova-volume;
do
    service "$i" stop
done

nova-manage db sync

for i in nova-api nova-compute nova-network nova-scheduler novnc nova-volume;
do
    service "$i" restart
done
