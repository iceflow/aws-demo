#!/bin/bash
# Ref: http://docs.aws.amazon.com/cli/latest/reference/sqs/

#QUEUE_NAME=test-queue

#aws sqs create-queue --queue-name ${QUEUE_NAME} --region eu-west-1



QUEUE_ENDPOINT="https://eu-west-1.queue.amazonaws.com/888250974927/inventory-list-queue"

#aws sqs send-message --queue-url ${QUEUE_ENDPOINT}  --message-body "Information about the largest city in Any Region." 

# 
#aws sqs receive-message --queue-url ${QUEUE_ENDPOINT}
