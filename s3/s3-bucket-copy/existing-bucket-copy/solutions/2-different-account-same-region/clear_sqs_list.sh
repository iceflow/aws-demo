#!/bin/bash


QUEUE_ENDPOINT="https://eu-west-1.queue.amazonaws.com/888250974927/s3-copy-list"
MAX_NUM=100

N=0


while [ 1 ]; do
    let N=$N+1
    [ $N -gt ${MAX_NUM} ] && exit 0

    Q="${QUEUE_ENDPOINT}-$N"

    aws sqs purge-queue --queue-url $Q

    echo "Purge queue $Q done"
    

done


exit 0
