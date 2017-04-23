#!/bin/bash

aws emr create-cluster --applications Name=Hadoop Name=Ganglia Name=Flink --tags 'Name=FlinkTest1' --ec2-attributes '{"KeyName":"us-east-1-test","InstanceProfile":"flink-refarch-infrastructure-EmrInstanceProfile-1LSR3RQLWSYBB","SubnetId":"subnet-a37a9ef9","EmrManagedSlaveSecurityGroup":"sg-3cc0fd43","EmrManagedMasterSecurityGroup":"sg-fdc1fc82","AdditionalMasterSecurityGroups":["sg-72c1fc0d"]}' --service-role EMR_DefaultRole --release-label emr-5.4.0 --name 'flink-refarch-infrastructure-cluster' --instance-groups '[{"InstanceCount":1,"EbsConfiguration":{"EbsBlockDeviceConfigs":[{"VolumeSpecification":{"SizeInGB":32,"VolumeType":"gp2"},"VolumesPerInstance":1}]},"InstanceGroupType":"MASTER","InstanceType":"m4.large","Name":"Master"},{"InstanceCount":2,"EbsConfiguration":{"EbsBlockDeviceConfigs":[{"VolumeSpecification":{"SizeInGB":32,"VolumeType":"gp2"},"VolumesPerInstance":1}]},"InstanceGroupType":"CORE","InstanceType":"c4.xlarge","Name":"Core"}]' --scale-down-behavior TERMINATE_AT_INSTANCE_HOUR --region us-east-1



# Login EMR Master and stard Flink daemon
ssh -C -D 8157 hadoop@ec2-52-91-87-241.compute-1.amazonaws.com -i us-east-1-test.pem
## Start long-term flink
HADOOP_CONF_DIR=/etc/hadoop/conf /usr/lib/flink/bin/yarn-session.sh -n 2 -s 4 -tm 4096 -d

## Start flink job
aws s3 cp s3://flink-refarch-build-artifacts-artifactbucket-4hf1iub58r4s/artifacts/flink-taxi-stream-processor-1.0.jar .
flink run -p 8 flink-taxi-stream-processor-1.0.jar --region us-east-1 --stream flink-refarch-infrastructure-KinesisStream-15IQN5FCMQQRP --es-endpoint https://search-flink-r-elasti-z1ew1n1gafm-nlha6xxxw3knbbviykhyffk2au.us-east-1.es.amazonaws.com --checkpoint



# Login Kinese Producer
ssh -C ec2-user@ec2-52-45-106-42.compute-1.amazonaws.com -i us-east-1-test.pem
aws s3 cp s3://flink-refarch-build-artifacts-artifactbucket-4hf1iub58r4s/artifacts/kinesis-taxi-stream-producer-1.0.jar .
java -jar kinesis-taxi-stream-producer-1.0.jar -speedup 1440 -stream flink-refarch-infrastructure-KinesisStream-15IQN5FCMQQRP -region us-east-1



# Kibana - Visualization
https://search-flink-r-elasti-z1ew1n1gafm-nlha6xxxw3knbbviykhyffk2au.us-east-1.es.amazonaws.com/_plugin/kibana/app/kibana#/dashboard/Taxi-Trips-Dashboard
