#!/bin/bash

aws --profile global_admin s3 sync /data/aws-demo/kms s3://leotest-virinia/kms
