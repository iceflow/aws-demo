#!/bin/bash

# Check etag : https://aws.amazon.com/cn/premiumsupport/knowledge-center/data-integrity-s3/

function run()
{
    echo $1
    $1
}


run "aws s3api head-object --bucket ireland-leo-test --key 200d070000002p1ozF356"
run "aws --profile leo@joyou s3api head-object --bucket ctripcorp-nephele-file-eu --key 200d070000002p1ozF356"
run "aws --profile joyou@ctrip s3api head-object --bucket ctripcorp-nephele-file-ireland  --key 200d070000002p1ozF356"


exit 0

Examples response:
aws s3api head-object --bucket ireland-leo-test --key 200d070000002p1ozF356
{
    "AcceptRanges": "bytes",
    "ContentType": "binary/octet-stream",
    "LastModified": "Fri, 22 Sep 2017 08:40:24 GMT",
    "ContentLength": 275771,
    "ETag": "\"c4034326960ffd3aa86683b9992a5a28\"",
    "Metadata": {
        "format": "jpg"
    }
}
aws --profile leo@joyou s3api head-object --bucket ctripcorp-nephele-file-eu --key 200d070000002p1ozF356
{
    "AcceptRanges": "bytes",
    "ContentType": "binary/octet-stream",
    "LastModified": "Thu, 03 Aug 2017 00:57:54 GMT",
    "ContentLength": 275771,
    "VersionId": "null",
    "ETag": "\"c4034326960ffd3aa86683b9992a5a28\"",
    "Metadata": {
        "format": "jpg"
    }
}
aws --profile joyou@ctrip s3api head-object --bucket ctripcorp-nephele-file-ireland --key 200d070000002p1ozF356
{
    "AcceptRanges": "bytes",
    "ContentType": "binary/octet-stream",
    "LastModified": "Wed, 09 Aug 2017 03:01:27 GMT",
    "ContentLength": 275771,
    "VersionId": "bKO661MaTDCZp_n3q1r0ofFMedmerM6E",
    "ETag": "\"c4034326960ffd3aa86683b9992a5a28\"",
    "Metadata": {
        "format": "jpg"
    }
}
