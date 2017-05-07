#!/bin/bash

REGION_LIST="cn-north-1"

PROFILE=$1

[ "_$PROFILE" = "_" ] && PROFILE=default

for R in ${REGION_LIST}; do
	# 1. 显示Connection状态
	echo "== Region $R ==="
	echo "=== Connections Status: ==="
	echo "connectionName,connectionState"
	aws --profile $PROFILE directconnect describe-connections --query 'connections[].[connectionName,connectionState]' --output text | awk '{print $1","$2}'

	CONNECTION_IDS=$(aws --profile $PROFILE directconnect describe-connections --query 'connections[].[connectionId]' --output text | xargs)

	# 2. 显示VIF状态
	echo "=== VIF status: ==="
	echo "connectionId,virtualInterfaceName,virtualInterfaceState"
	for C in ${CONNECTION_IDS}; do
		aws --profile $PROFILE directconnect describe-virtual-interfaces --connection-id $C --query 'virtualInterfaces[].[connectionId,virtualInterfaceName,virtualInterfaceState]' --output text | awk '{print $1","$2","$3}'
	done
done
