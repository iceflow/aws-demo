#!/bin/bash
# File: compare_faces.sh

P=leo@nwcdleo.global
R=us-east-2
aws --region $R --profile $P rekognition compare-faces \
    --source-image '{"S3Object":{"Bucket":"leo-test-ohio","Name":"原图裁剪.png"}}' \
    --target-image '{"S3Object":{"Bucket":"leo-test-ohio","Name":"凡凡临摹.jpeg"}}'
