#!/bin/bash


aws iam create-role --role-name SSMServiceRole --assume-role-policy-document file://SSMService-Trust.json 


#aws iam attach-role-policy --role-name SSMServiceRole --policy-arn arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM 
aws iam attach-role-policy --role-name SSMServiceRole --policy-arn arn:aws-cn:iam::aws:policy/service-role/AmazonEC2RoleforSSM 


# Activator
#aws ssm create-activation --default-instance-name MyWebServers --iam-role RunCommandServiceRole –-registration-limit 10 --region cn-north-1
aws ssm create-activation --default-instance-name MyWebServers --iam-role SSMServiceRole --registration-limit 10 --region cn-north-1



# Register 
mkdir /tmp/ssm
sudo curl https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb -o /tmp/ssm/amazon-ssm-agent.deb
sudo dpkg -i /tmp/ssm/amazon-ssm-agent.deb
sudo service amazon-ssm-agent stop
sudo amazon-ssm-agent -register -code "KcvPUlujNvv6Ph9Xi/2H" -id "b4d9519c-4642-4747-9497-88b678f6a1c3" -region "cn-north-1" 
sudo service amazon-ssm-agent start
