#!/bin/bash





while [ 1 ]; do
    N=`/data/s3-copy/check_sqs_list.py https://eu-west-1.queue.amazonaws.com/888250974927/s3-copy-list 100`

    echo "`date`: $N" >> check_sqs.log

    sleep 3600
done
