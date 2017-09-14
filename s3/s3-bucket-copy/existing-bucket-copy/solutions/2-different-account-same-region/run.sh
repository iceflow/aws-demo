#!/bin/bash

# Source bucket in AWS leo account s3://leo-collections
SRC_INVENTORY=s3://leo-aws-inventory/aws-collections/aws-collections-inventory/2017-09-05T00-16Z

# Destination bucket in AWS chenlintao@gmail.com private account s3://leo-collections-copy
#  aws --profile chenlintao-admin s3 mb s3://leo-collections-copy
DST_BUCKET=s3://leo-collections-copy



function s3_download()
{
    aws s3 cp $1 .
}


function run()
{
    # 1. Download and parse inventory
    s3_download ${SRC_INVENTORY}/manifest.json
    s3_download ${SRC_INVENTORY}/manifest.checksum

    # 2. Copy to destination 

}

run ${SRC_INVENTORY} ${DST_BUCKET}

exit 0
