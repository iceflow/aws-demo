#!/bin/bash

aws emr create-cluster --termination-protected --applications  \
	Name=Hadoop Name=Hive Name=Pig Name=Hue Name=Ganglia Name=Zeppelin Name=Tez Name=Spark Name=Sqoop Name=Oozie Name=Presto \
	--tags 'Name=Demo1-EMR-5.5.0' \
	--ec2-attributes '{"KeyName":"poc","InstanceProfile":"EMR_EC2_DefaultRole","SubnetId":"subnet-59433d3c","EmrManagedSlaveSecurityGroup":"sg-5c51fe38","EmrManagedMasterSecurityGroup":"sg-1d52fd79"}' \
	--release-label emr-5.5.0 \
	--log-uri 's3n://aws-logs-358620020600-cn-north-1/elasticmapreduce/' \
	--instance-groups '[{"InstanceCount":1,"InstanceGroupType":"MASTER","InstanceType":"m3.xlarge","Name":"主实例组 - 1"},{"InstanceCount":4,"InstanceGroupType":"CORE","InstanceType":"m3.xlarge","Name":"核心实例组 - 2"}]' \
	--configurations file://hiveConfiguration.json \
	--service-role EMR_DefaultRole \
	--enable-debugging \
	--name 'Demo1-EMR-5.5.0' \
	--scale-down-behavior TERMINATE_AT_INSTANCE_HOUR \
	--region cn-north-1
