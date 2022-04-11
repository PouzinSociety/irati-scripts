#!/bin/bash -e

ip link add link enp0s3 name enp0s3.100 type vlan id 100
ip link set dev enp0s3.100 up

