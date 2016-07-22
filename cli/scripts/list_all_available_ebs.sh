#!/bin/bash


REGION_LIST=`awk '{print $NF}' region_list.conf | xargs`

PROFILE=$1


for R in ${REGION_LIST}; do
	if [ "_$PROFILE" != "_" ]; then
        aws --profile $1 ec2 --region $R describe-volumes --query 'Volumes[].[AvailabilityZone,VolumeId,State,Iops,Size]' --filter Name=status,Values=available --output text
	else
        aws ec2 --region $R describe-volumes --query 'Volumes[].[AvailabilityZone,VolumeId,State,Iops,Size]' --filter Name=status,Values=available --output text
	fi
done
