#!/bin/bash

REGION_LIST="cn-north-1"

PROFILE=$1

[ "_$PROFILE" = "_" ] && PROFILE=default



for R in ${REGION_LIST}; do

# 1. 显示Connection状态

    #echo "AvailabilityZone,VolumeId,State,Iops,Size,VolumeType"
    #aws ec2 --profile $PROFILE describe-volumes --query 'Volumes[].[AvailabilityZone,VolumeId,State,Iops,Size,VolumeType]' --output text | awk '{print $1","$2","$3","$4","$5","$6}'

	echo "== Region $R ==="
    echo "=== Connections Status: ==="
	echo "connectionName,connectionState"
	aws --profile $PROFILE directconnect describe-connections --query 'connections[].[connectionName,connectionState]' --output text | awk '{print $1","$2}'


	CONNECTION_IDS=$(aws --profile $PROFILE directconnect describe-connections --query 'connections[].[connectionId]' --output text | xargs)


# 2. 显示VIF状态

	echo "=== VIF status: ==="
	echo "connectionId,virtualInterfaceName,virtualInterfaceState"
	for C in ${CONNECTION_IDS}; do
	#aws --profile $PROFILE directconnect describe-virtual-interfaces --connection-id dxcon-ffjrkx17
		aws --profile $PROFILE directconnect describe-virtual-interfaces --connection-id $C --query 'virtualInterfaces[].[connectionId,virtualInterfaceName,virtualInterfaceState]' --output text | awk '{print $1","$2","$3}'

	done

done
