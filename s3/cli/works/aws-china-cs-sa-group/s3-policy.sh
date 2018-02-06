#!/bin/bash

# Ref:
# http://docs.aws.amazon.com/cli/latest/reference/s3api/get-bucket-policy.html

P=default
B=$(basename `pwd`)

# Get bucket policy
aws --profile $P s3api get-bucket-policy --bucket $B

#exit 0

# Pub bucket poicy
aws --profile $P s3api put-bucket-policy --bucket $B --policy file://$B-policy.json

aws --profile $P s3api get-bucket-policy --bucket $B
