#!/bin/bash

# Ref:
# http://docs.aws.amazon.com/cli/latest/reference/s3api/get-bucket-policy.html


# Get bucket policy
aws --profile default s3api get-bucket-policy --bucket leo-test-s3

# Pub bucket poicy
aws --profile default s3api put-bucket-policy --bucket leo-test-s3 --policy file://leo-test-s3-policy.json

aws --profile default s3api get-bucket-policy --bucket leo-test-s3
