#!/bin/bash

aws emr create-cluster --termination-protected --applications  \
    Name=Hadoop Name=Hive Name=Pig Name=Hue Name=Ganglia Name=Zeppelin Name=Tez Name=Spark Name=Sqoop Name=Oozie Name=Presto \
    --tags 'Name=Demo-EMR-5.8.0' \
    --ec2-attributes '{"KeyName":"ireland-bastion", "InstanceProfile":"EMR_EC2_DefaultRole"}' \
    --release-label emr-5.8.0 \
    --log-uri 's3n://aws-logs-888250974927-eu-west-1/elasticmapreduce/' \
    --instance-groups '[{"InstanceCount":1,"InstanceGroupType":"MASTER","InstanceType":"m3.xlarge","Name":"主实例组 - 1"},{"InstanceCount":2,"InstanceGroupType":"CORE","InstanceType":"m3.xlarge","Name":"核心实例组 - 2"}]' \
    --service-role EMR_DefaultRole \
    --enable-debugging \
    --name 'Demo-EMR-5.8.0' \
    --scale-down-behavior TERMINATE_AT_INSTANCE_HOUR \
    --region eu-west-1
