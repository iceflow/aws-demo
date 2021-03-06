#!/bin/bash

# Ref:
# http://docs.aws.amazon.com/cli/latest/reference/s3api/get-bucket-policy.html


# Get bucket policy
aws --profile nwcdlabs s3api get-bucket-policy --bucket reinvent


#exit 0

# Pub bucket poicy
aws --profile nwcdlabs s3api put-bucket-policy --bucket reinvent --policy file://reinvent-policy.json

aws --profile nwcdlabs s3api get-bucket-policy --bucket reinvent
