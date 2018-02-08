#!/bin/bash


#aws cloudwatch get-metric-statistics --metric-name BucketSizeBytes --namespace AWS/S3 --start-time 2016-10-19T00:00:00Z --end-time 2016-10-20T00:00:00Z --statistics Average --unit Bytes --region us-west-2 --dimensions Name=BucketName,Value=ExampleBucket Name=StorageType,Value=StandardStorage --period 86400 --output json


#aws cloudwatch list-metrics --namespace "AWS/S3"

#exit 0


aws --profile chinakb cloudwatch get-metric-statistics --metric-name BucketSizeBytes --namespace AWS/S3 --start-time 2017-12-24T00:00:00Z --end-time 2017-12-25T00:00:00Z --statistics Average --unit Bytes --region cn-north-1 --dimensions Name=BucketName,Value=reinvent Name=StorageType,Value=StandardStorage --period 86400 --output json

aws --profile chinakb cloudwatch get-metric-statistics --metric-name NumberOfObjects --namespace AWS/S3 --start-time 2017-12-24T00:00:00Z --end-time 2017-12-25T00:00:00Z --statistics Average --unit Count --region cn-north-1 --dimensions Name=BucketName,Value=reinvent Name=StorageType,Value=AllStorageTypes --period 86400 --output json




exit 0

# 1 week pre-signed_url
#./s3_demo.py generate_presigned_url default leoaws public/devops_decks.bz2 604800


L="htsc-ebc/DavidPellerin_EBC250+How+to+Cultivate+an+Innovation-Driven+Culture.pptx"
L="htsc-ebc/DevOps_ProServe_HuataiSecuritiesFINAL.pptx $L"
L="htsc-ebc/EricWazorko_Finra_Huatai+Briefing.pptx $L"
L="htsc-ebc/PeterWilliams_AWS+FSI+-+Huatai+Securities.pptx $L"
L="$L"

#
arr[0]="htsc-ebc/DavidPellerin_EBC250 How to Cultivate an Innovation-Driven Culture.pptx"
arr[1]="htsc-ebc/DevOps_ProServe_HuataiSecuritiesFINAL.pptx"
arr[2]="htsc-ebc/EricWazorko_Finra_Huatai Briefing.pptx"
arr[3]="htsc-ebc/PeterWilliams_AWS FSI - Huatai Securities.pptx"

L="htsc-ebc/DavidPellerin_EBC250 How to Cultivate an Innovation-Driven Culture.pptx"


P=default
B=leoaws
E=604800


for item in ${arr[*]}; do
	echo "Processing $item ....."
#	eval './s3_demo.py generate_presigned_url $P $B "$item" $E'
done

exit 0
