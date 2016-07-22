#!/bin/bash

# List active clusters
aws emr list-clusters --active

aws emr add-steps --cluster-id j-3GYXXXXXX9IOK --steps Type=CUSTOM_JAR,Name="S3DistCp step",Jar=/home/hadoop/lib/emr-s3distcp-1.0.jar,\
Args=["--s3Endpoint,s3-eu-west-1.amazonaws.com","--src,s3://mybucket/logs/j-3GYXXXXXX9IOJ/node/","--dest,hdfs:///output","--srcPattern,.*[a-zA-Z,]+"]
