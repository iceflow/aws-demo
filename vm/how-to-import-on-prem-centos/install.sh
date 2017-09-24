#!/bin/bash

# How to enable enhanced networking on CentOS6
# 1. Enable instance SR-IOV
# 2. Update CentOS and install newest ixgbevf driver
# 3. Install cloud-init
#    After install cloud-init ; reboot ; you will need pem to and username 'centos' to login
# 4. Clear iptable ip6tables
# 5. reboot confirm
# 6. Make AMI
# 7. Partition Change to use full ebs size : http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/storage_expand_partition.html
#    Mount root volume to another Amazon Linux, and using http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/storage_expand_partition.html#part-resize-gdisk
#  http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-expand-volume.html#recognize-expanded-volume-linux
#  e2fsck -f /dev/xvdg1
#  resize2fs /dev/xvdg1



yum update

reboot

yum -y install wget kernel-deve

# Getting https://sourceforge.net/projects/e1000/files/ixgbevf%20stable/4.2.2/

tar zxpf ixgbevf-4.2.2.tar.gz

cd ixgbevf-4.2.2/src

make install

yum -y install cloud-init

chkconfig --level 345 iptables off
chkconfig --level 345 ip6tables off

reboot

# install files

filename:       /lib/modules/2.6.32-696.10.2.el6.x86_64/updates/drivers/net/ethernet/intel/ixgbevf/ixgbevf.ko
version:        4.2.2

filename:       /lib/modules/2.6.32-696.10.2.el6.x86_64/kernel/drivers/net/ixgbevf/ixgbevf.ko
version:        2.12.1-k


# ethtool -i eth0
driver: ixgbevf
version: 4.2.2
firmware-version: N/A
bus-info: 0000:00:03.0
supports-statistics: yes
supports-test: yes
supports-eeprom-access: no
supports-register-dump: yes
supports-priv-flags: no

exit 0

exit 0
