#!/bin/bash


#aws s3 cp sample.txt s3://fake-musically-bigdata/allen.li/output/blueberry/model_feeds/sample.txt

aws --profile leo-root s3 ls s3://fake-musically-bigdata/allen.li/output/blueberry/model_feeds/sample.txt
