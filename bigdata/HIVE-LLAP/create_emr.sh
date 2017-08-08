#!/bin/bash

aws --profile chinakb emr create-cluster --release-label emr-5.7.0 \
--applications Name=Hadoop Name=Hive Name=Hue Name=ZooKeeper Name=Tez  \
--bootstrap-actions '[{"Path":"s3://awssupportdatasvcs.com/bootstrap-actions/Hive/hive-llap/configure-Hive-LLAP.sh","Name":"Custom action"}]'  \
--ec2-attributes '{"KeyName":"chinakb-leo","InstanceProfile":"EMR_EC2_DefaultRole","SubnetId":"subnet-402e2634"}' \
--service-role EMR_DefaultRole \
--enable-debugging \
--log-uri 's3n://chinakb-logs/' --name 'test-hive-llap' \
--instance-groups '[{"InstanceCount":1,"EbsConfiguration":{"EbsBlockDeviceConfigs":[{"VolumeSpecification":{"SizeInGB":32,"VolumeType":"gp2"},"VolumesPerInstance":1}],"EbsOptimized":true},"InstanceGroupType":"MASTER","InstanceType":"m4.xlarge","Name":"Master - 1"},{"InstanceCount":3,"EbsConfiguration":{"EbsBlockDeviceConfigs":[{"VolumeSpecification":{"SizeInGB":32,"VolumeType":"gp2"},"VolumesPerInstance":1}],"EbsOptimized":true},"InstanceGroupType":"CORE","InstanceType":"m4.xlarge","Name":"Core - 2"}]' \
--region cn-north-1


exit 0
