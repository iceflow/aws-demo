#!/bin/bash


REGION_LIST=`awk '{print $NF}' region_list.conf | xargs`

PROFILE=$1


for R in ${REGION_LIST}; do
	if [ "_$PROFILE" != "_" ]; then
		aws --profile $1 ec2 --region $R describe-instances --query 'Reservations[*].Instances[*].[Placement.AvailabilityZone, State.Name, InstanceId, InstanceType]' --filter Name=instance-state-code,Values=16 --output text 
	else
		aws ec2 --region $R describe-instances --query 'Reservations[*].Instances[*].[Placement.AvailabilityZone, State.Name, InstanceId, InstanceType]' --filter Name=instance-state-code,Values=16 --output text 
	fi
done
