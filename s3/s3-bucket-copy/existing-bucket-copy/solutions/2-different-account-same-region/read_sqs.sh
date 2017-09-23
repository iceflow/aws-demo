#!/bin/bash


nohup /data/s3-copy/s3_copy_from_sqs.py https://eu-west-1.queue.amazonaws.com/888250974927/s3-copy-list 100 https://eu-west-1.queue.amazonaws.com/888250974927/s3-copy-list-dead-queue > /dev/null 2>&1 &
