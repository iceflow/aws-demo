#!/bin/bash

# Read tasks from SQS and copy S3 objects accordingly


QUEUE_ENDPOINT="https://eu-west-1.queue.amazonaws.com/888250974927/inventory-list-queue"
CHECK_INTERVAL=10


function delete_message() {
    aws sqs delete-message --queue-url ${QUEUE_ENDPOINT} --receipt-handle $1
}

function do_work() {
    MESSAGE=`aws sqs receive-message --queue-url ${QUEUE_ENDPOINT}`
    echo "MESSAGE=[$MESSAGE]"
    [ "_$MESSAGE" = "_" ] && return 1
    BODY=`echo $MESSAGE | jq '.Messages[].Body'`
    RECEIPT_HANDLE=`echo $MESSAGE | jq '.Messages[].ReceiptHandle' | cut -d\" -f2`
    # "ctripcorp-nephele-file-eu,fd/tg/g3/M08/E6/52/CggYG1bhZkqAShNYAAIACcPtNw0847.jpg,ireland-leo-test"

    echo $BODY
    echo ${MESSAGE_ID}

    SRC_BUCKET=`echo $BODY|cut -d, -f1|cut -d\" -f2`
    SRC_KEY=`echo $BODY|cut -d, -f2`
    DST_BUCKET=`echo $BODY|cut -d, -f3|cut -d\" -f1`

    aws s3 cp s3://${SRC_BUCKET}/${SRC_KEY} s3://${DST_BUCKET}/${SRC_KEY}

    [ $? -eq 0 ] && delete_message ${RECEIPT_HANDLE}

    return 0

}

while [ 1 ]; do
    do_work

    [ $? -eq 0 ] && continue

    echo "Empty Now. Check within ${CHECK_INTERVAL} seconds....."
    sleep ${CHECK_INTERVAL}
done

exit 0
