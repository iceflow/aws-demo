#!/bin/bash

# Source bucket in AWS leo account s3://leo-collections
SRC_INVENTORY_BUCKET=leo-aws-inventory
SRC_BUCKET=aws-collections
SRC_INVENTORY_DIR=${SRC_INVENTORY_BUCKET}/${SRC_BUCKET}/aws-collections-inventory/2017-09-05T00-16Z


# Destination bucket in AWS chenlintao@gmail.com private account s3://leo-collections-copy
#  aws --profile chenlintao-admin s3 mb s3://leo-collections-copy
DST_BUCKET=leo-collections-copy



function s3_download()
{
    echo "Downloading[$1]"

    aws s3 cp $1 .
}


function run()
{
    # 1. Download and parse inventory
    s3_download s3://${SRC_INVENTORY_DIR}/manifest.json
    s3_download s3://${SRC_INVENTORY_DIR}/manifest.checksum

    # 2. Copy to destination 

}

#run ${SRC_INVENTORY} ${DST_BUCKET}


s3_download "s3://${SRC_INVENTORY_BUCKET}/${SRC_BUCKET}/aws-collections-inventory/data/932e1c8c-2784-4778-9cb7-eab83bfb5b47.csv.gz"

exit 0
