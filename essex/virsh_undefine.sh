#!/bin/bash

for i in `virsh list --all | grep instance | awk '{print $2}'`; do
    virsh destroy "$i"
    virsh undefine --managed-save "$i"
done
