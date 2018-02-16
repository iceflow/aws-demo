#!/bin/bash


pushd /data/aws-demo/s3/s3-bucket-copy/existing-bucket-copy/solutions/2-different-account-same-region

    ./ctrip_cdn.sh
    aws s3 sync ctrip-cdn-logs/ s3://aws-china-cs-sa-group/sample-data/cloudfront-logs/ctrip-201802-test/cf-logs/

popd
