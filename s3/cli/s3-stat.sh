#!/bin/bash


PROFILE=default


get_s3_bucket_stat()
{
	BUCKET_NAME=$1
	REGION=$2
	PROFILE=$3

	TODAY=`date -d now +%Y-%m-%d`
	TOMORROW=`date -d tomorrow +%Y-%m-%d`
	

#--query 'Reservations[*].Instances[*].[Placement.AvailabilityZone, State.Name, InstanceId]

	Location=$(aws --profile $PROFILE s3api get-bucket-location --bucket ${BUCKET_NAME} --output text)

	#aws --profile $PROFILE cloudwatch get-metric-statistics --metric-name BucketSizeBytes --namespace AWS/S3 --start-time ${TODAY}T00:00:00Z --end-time ${TOMORROW}T00:00:00Z --statistics Average --unit Bytes --region $REGION --dimensions Name=BucketName,Value=${BUCKET_NAME} Name=StorageType,Value=StandardStorage --period 86400 --output json --query '[Label, Datapoints.[Average, Timestamp, Unit]]'
	BucketSizeBytes=$(aws --profile $PROFILE cloudwatch get-metric-statistics --metric-name BucketSizeBytes --namespace AWS/S3 --start-time ${TODAY}T00:00:00Z --end-time ${TOMORROW}T00:00:00Z --statistics Average --unit Bytes --region $REGION --dimensions Name=BucketName,Value=${BUCKET_NAME} Name=StorageType,Value=StandardStorage --period 86400 --output text --query '[Datapoints[0].[Average,Timestamp,Unit]]')

	NumberOfObjects=$(aws --profile $PROFILE cloudwatch get-metric-statistics --metric-name NumberOfObjects --namespace AWS/S3 --start-time ${TODAY}T00:00:00Z --end-time ${TOMORROW}T00:00:00Z --statistics Average --unit Count --region $REGION --dimensions Name=BucketName,Value=${BUCKET_NAME} Name=StorageType,Value=AllStorageTypes --period 86400 --output text --query '[Datapoints[0].[Average,Timestamp,Unit]]')

	echo "${BUCKET_NAME} ${Location} BucketSizeBytes ${BucketSizeBytes} NumberOfObjects ${NumberOfObjects}"

}

#get_s3_bucket_stat reinvent cn-north-1 chinakb


ALL_BUCKETS=$(aws --profile $PROFILE s3api list-buckets --query 'Buckets[].[Name]' --output text | xargs )

for bucket in ${ALL_BUCKETS}; do

	get_s3_bucket_stat $bucket cn-north-1 $PROFILE

done


exit 0
