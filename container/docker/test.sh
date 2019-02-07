#!/bin/bash


docker run -it busybox /bin/sh




#mount -t cgroup

#cpu.cfs_quota_us
#cpu.cfs_period_us

docker run -it --cpu-period=100000 --cpu-quota=20000 ubuntu /bin/bash


docker info



docker image inspect ubuntu:latest
