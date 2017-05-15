#!/bin/bash

#### EC2 启动实例 #####
# 启动内网dhcp实例
aws ec2 run-instances --image-id ami-f239abcb --count 1 --instance-type t2.micro --key-name test --security-group-ids sg-0ada386f --subnet-id subnet-13e0c867
# 启动内网固定IP实例
aws ec2 run-instances --image-id ami-f239abcb --count 1 --instance-type t2.micro --key-name test --security-group-ids sg-0ada386f --subnet-id subnet-13e0c867 --private-ip-address 172.31.16.12
# 启动内网固定IP,并绑定公网IP(非EIP)
aws ec2 run-instances --image-id ami-f239abcb --count 1 --instance-type t2.micro --key-name test --security-group-ids sg-0ada386f --subnet-id subnet-13e0c867 --private-ip-address 172.31.16.13 --associate-public-ip-address

# 启动的时候增加EC2/EBS tags
aws ec2 run-instances --image-id ami-162c2575 --count 1 --instance-type t2.micro --subnet-id subnet-6e7de837 --tag-specifications 'ResourceType=instance,Tags=[{Key=webserver,Value=production}]' 'ResourceType=volume,Tags=[{Key=cost-center,Value=cc123}]'  --region ap-southeast-2

#### 列出EC2实例信息 ####
# 列出所有instance信息
aws ec2 describe-instances

aws ec2 describe-instances --filters "Name=instance-type,Values=m1.small"
aws ec2 describe-instances --filters "Name=tag-key,Values=Owner"
aws ec2 describe-instances --filters "Name=tag:Purpose,Values=test"
# 带过滤条件，列出instance部分信息
aws ec2 describe-instances --query 'Reservations[*].Instances[*].[Placement.AvailabilityZone, State.Name, InstanceId]' --output text

#### EIP 操作 ####
###### 查看EIP列表
aws ec2 describe-addresses --output table
###### 申请EIP
aws ec2 allocate-address
###### 释放EIP
aws ec2 release-address --allocation-id eipalloc-64d5890a
###### EC2 绑定EIP ####
# 单网卡, 单IP模式
aws ec2 associate-address --instance-id i-4da5a8e6 --public-ip 54.223.192.55
# 多网卡, 多IP模式, 实际上每个EIP对应的是一个内网IP
aws ec2 associate-address --allocation-id eipalloc-7b140819 --network-interface-id eni-da448bbe --private-ip-address 10.0.1.71
###### EC2 解除绑定EIP ####
aws ec2 disassociate-address --public-ip 198.51.100.0


### ENI 网卡申请
aws ec2 create-network-interface --subnet-id subnet-9d4a7b6c --description "my network interface" --groups sg-903004f8 --private-ip-address 10.0.2.17

## ENI 上私有IP设定
# 指定私有IP
aws ec2 assign-private-ip-addresses --network-interface-id eni-e5aa89a3 --private-ip-addresses 10.0.0.82
# 指定私有IP数量
aws ec2 assign-private-ip-addresses --network-interface-id eni-e5aa89a3 --secondary-private-ip-address-count 2


