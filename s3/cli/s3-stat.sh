#!/bin/bash



PROFILE=${1:-default}
DEBUG=false


do_debug()
{
	[ $DEBUG == true ] && echo "$1"
}
err_quit()
{
	echo "ERR_QUIT: $1"
	exit 1
}

get_s3_bucket_stat()
{
	BUCKET_NAME=$1
	REGION=$2
	PROFILE=$3

	YESTODAY=`date -d "1 days ago"  +%Y-%m-%d`
	TODAY=`date -d now +%Y-%m-%d`
	TOMORROW=`date -d tomorrow +%Y-%m-%d`
	

#--query 'Reservations[*].Instances[*].[Placement.AvailabilityZone, State.Name, InstanceId]
	#aws --profile $PROFILE cloudwatch get-metric-statistics --metric-name BucketSizeBytes --namespace AWS/S3 --start-time ${TODAY}T00:00:00Z --end-time ${TOMORROW}T00:00:00Z --statistics Average --unit Bytes --dimensions Name=BucketName,Value=${BUCKET_NAME} Name=StorageType,Value=StandardStorage --period 86400 --output json --query '[Label, Datapoints.[Average, Timestamp, Unit]]'
	BucketSizeBytes=$(aws --profile $PROFILE --region $REGION cloudwatch get-metric-statistics --metric-name BucketSizeBytes --namespace AWS/S3 --start-time ${YESTODAY}T00:00:00Z --end-time ${TODAY}T00:00:00Z --statistics Average --unit Bytes --dimensions Name=BucketName,Value=${BUCKET_NAME} Name=StorageType,Value=StandardStorage --period 86400 --output text --query '[Datapoints[0].[Average,Timestamp,Unit]]')

	[ $? -ne 0 ] && err_quit "${BUCKET_NAME} Do caculate BucketSizeBytes"

	NumberOfObjects=$(aws --profile $PROFILE --region $REGION cloudwatch get-metric-statistics --metric-name NumberOfObjects --namespace AWS/S3 --start-time ${YESTODAY}T00:00:00Z --end-time ${TODAY}T00:00:00Z --statistics Average --unit Count --dimensions Name=BucketName,Value=${BUCKET_NAME} Name=StorageType,Value=AllStorageTypes --period 86400 --output text --query '[Datapoints[0].[Average,Timestamp,Unit]]')

	[ $? -ne 0 ] && err_quit "${BUCKET_NAME} Do caculate NumberOfObjects"

	echo "${BUCKET_NAME} ${REGION} BucketSizeBytes ${BucketSizeBytes} NumberOfObjects ${NumberOfObjects}"

}

#get_s3_bucket_stat reinvent cn-north-1 chinakb

get-bucket-location()
{
	BUCKET_NAME=$1
	PROFILE=$2

    R=$(aws --profile $PROFILE s3api get-bucket-location --bucket ${BUCKET_NAME} --output text)

	[ $? -ne 0 ] && err_quit "get-bucket-location"

    if [ "_$R" = "_None" ]; then
        R="us-east-1"
    fi

    echo $R

}

ALL_BUCKETS=$(aws --profile $PROFILE s3api list-buckets --query 'Buckets[].[Name]' --output text | xargs )
#ALL_BUCKETS="leopublic"

do_debug "${ALL_BUCKETS}"
#exit 0

for bucket in ${ALL_BUCKETS}; do

	do_debug "===== Process $bucket ======"

    region=$(get-bucket-location $bucket $PROFILE)

	if [ $? -eq 0 ]; then
		get_s3_bucket_stat $bucket $region $PROFILE
	else
		do_debug "Failed...."
	fi


done


exit 0
