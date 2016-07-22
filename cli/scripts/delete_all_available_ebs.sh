#!/bin/bash


REGION_LIST=`awk '{print $NF}' region_list.conf | xargs`

PROFILE=$1


for R in ${REGION_LIST}; do
	if [ "_$PROFILE" != "_" ]; then
        CMD="aws --profile $1 ec2 --region $R describe-volumes --query 'Volumes[].[VolumeId]' --filter Name=status,Values=available --output text "
	else
        CMD="aws ec2 --region $R describe-volumes --query 'Volumes[].[VolumeId]' --filter Name=status,Values=available --output text"
	fi

	#aws --region $R ec2 delete-volume --volume-id 

	eval $CMD | awk '{print "echo "$1"; aws --region "R" ec2 delete-volume --volume-id "$1}' R=$R

done
