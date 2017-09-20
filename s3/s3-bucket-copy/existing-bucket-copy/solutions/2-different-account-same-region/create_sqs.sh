#!/bin/bash

QUEUE_NAME=s3-copy-list
REGION=eu-west-1
QUEUE_NUM=100

DEAD_QUEUE=arn:aws:sqs:eu-west-1:888250974927:s3-copy-list-dead-queue

VISIBILITY_TIMEOUT=3600

N=1

function create_dead_queue() {
    # Create Dead Queue
#    DEAD_QUEUE=`aws sqs create-queue --queue-name "${QUEUE_NAME}-dead-queue" --attributes VisibilityTimeout=${VISIBILITY_TIMEOUT} --region ${REGION} | jq .'QueueUrl' | cut -d\" -f2`
    echo "{
      \"RedrivePolicy\": \"{\\\"deadLetterTargetArn\\\":\\\"${DEAD_QUEUE}\\\",\\\"maxReceiveCount\\\":\\\"1000\\\"}\",
      \"VisibilityTimeout\": \"${VISIBILITY_TIMEOUT}\"
    } " > create-queue.json

    return 0
}

create_dead_queue

while [ 1 ]; do
    echo $N
    [ $N -gt ${QUEUE_NUM} ] && break

    aws sqs create-queue --queue-name ${QUEUE_NAME}-$N --attributes file://create-queue.json --region ${REGION} 

    let N=$N+1
done

exit 0
