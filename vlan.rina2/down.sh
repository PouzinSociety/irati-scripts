#!/bin/bash -e

ip link set dev enp0s3.100 down
ip link delete enp0s3.100

