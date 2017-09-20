#!/bin/bash

ROLE_ARN=arn:aws:iam::064838511194:role/get-s3-inventory-list-role
INVENTORY_BUCKET=joyou-inventory-list
INVENTORY_DIR=s3://${INVENTORY_BUCKET}/ctripcorp-nephele-file-eu/ctripcore-all/2017-09-19T00-08Z
QUEUE_ENDPOINT="https://eu-west-1.queue.amazonaws.com/888250974927/s3-copy-list"
DST_BUCKET=ireland-leo-test
LOCAL_INVENTORY_DIR=inventory_files_test

# How many SQS to use
QUEUE_NUM=100
# How many objects in one message body
MESSAGE_BODY_NUM=100
TMP_MESSAGE_BODY_FILE=/tmp/message_body.file
TMP_RUN_FILE=/tmp/sendmessage_run.sh

# Initial
QN=0

function get_temp_credential() {
    #arn:aws:iam::064838511194:role/get-s3-inventory-list-role

    TEMP_CREDENTIAL_FILE='/tmp/temp.credential'

    aws --profile default sts assume-role --role-arn ${ROLE_ARN} --role-session-name test --output json > ${TEMP_CREDENTIAL_FILE}

    export AWS_ACCESS_KEY_ID=$(cat ${TEMP_CREDENTIAL_FILE} | jq ".Credentials.AccessKeyId"|cut -d\" -f2)
    export AWS_SECRET_ACCESS_KEY=$(cat ${TEMP_CREDENTIAL_FILE} | jq ".Credentials.SecretAccessKey"|cut -d\" -f2)
    export AWS_SESSION_TOKEN=$(cat ${TEMP_CREDENTIAL_FILE} | jq ".Credentials.SessionToken"|cut -d\" -f2)

    [ -f ${TEMP_CREDENTIAL_FILE} ] && rm -f ${TEMP_CREDENTIAL_FILE}

    return 0
}

function download_inventory_list() {
    #aws --profile leo@joyou s3 ls s3://leo-test-ireland/
    #aws --profile leo@joyou s3 cp s3://leo-test-ireland/test.txt .

    # Getting TempCred

    # Environment variables – AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, and AWS_SESSION_TOKEN. 
    # http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html 

    aws s3 cp $1/manifest.json .
    aws s3 cp $1/manifest.checksum .

    # TODO: Check file integrity
    # md5-check manifest.json manifest.checksum

    return 0
}


function download_inventory_files() {

    [ -d ${LOCAL_INVENTORY_DIR} ] || mkdir -p ${LOCAL_INVENTORY_DIR}
    
    FILES=`cat manifest.json | jq ".files[].key"` 

    for F in $FILES; do
        KEY=`echo $F|cut -d\" -f2`
        eval "aws s3 cp s3://${INVENTORY_BUCKET}/$KEY ${LOCAL_INVENTORY_DIR}/"
    done

    return 0
}

function send_message_to_sqs() {
    let QN=${QN}+1

    [ ${QN} -gt ${QUEUE_NUM} ] && QN=1
    echo "aws sqs send-message --queue-url ${QUEUE_ENDPOINT}-${QN}  --message-body $1" >> ${TMP_RUN_FILE}

}

function send_files_to_sqs() {
#cat inventory_files/0022d4cd-3a32-4477-90fb-aee895e8a136.csv.gz
# SQS
# aws sqs create-queue --queue-name inventory-list-queue --region eu-west-1

    [ -d ${LOCAL_INVENTORY_DIR} ] || return 1
    

    for F in ${LOCAL_INVENTORY_DIR}/*; do
        echo "Parsing $F..."
        N=0
        MESSAGE_BODY=""
        echo > ${TMP_RUN_FILE}
        zcat $F | while read L; do
        # "ctripcorp-nephele-file-eu","fd/tg/g3/M08/E6/51/CggYG1Y26zCAfj-uAAFPZF8NV_g821.jpg","85860","2017-08-09T07:07:56.000Z","d0655f3673af1ca741b11b29865be8e1","STANDARD","false",""
            let N=$N+1

            SRC_BUCKET=`echo $L|cut -d, -f1|cut -d\" -f2`
            SRC_KEY=`echo $L|cut -d, -f2|cut -d\" -f2`

            echo "${SRC_BUCKET},${SRC_KEY},${DST_BUCKET}" >> ${TMP_MESSAGE_BODY_FILE}

            #echo "N=$N"
            #echo "${MESSAGE_BODY}"

            if [ $N -eq ${MESSAGE_BODY_NUM} ]; then
                send_message_to_sqs `cat ${TMP_MESSAGE_BODY_FILE} | xargs | sed 's/ /:/g'`
                [ -f ${TMP_MESSAGE_BODY_FILE} ] && rm -f ${TMP_MESSAGE_BODY_FILE}
                N=0
            fi
        done

        if [ -f ${TMP_MESSAGE_BODY_FILE} ]; then
            send_message_to_sqs `cat ${TMP_MESSAGE_BODY_FILE} | xargs | sed 's/ /:/g'`
            rm -f ${TMP_MESSAGE_BODY_FILE}
        fi

        # Run
        /bin/bash ${TMP_RUN_FILE}
    done

    return 0
}

function send_files_to_sqs_python() {
    CMD="./inventory_files_to_sqs.py"

    $CMD ${LOCAL_INVENTORY_DIR} ${DST_BUCKET}

}
#aws sqs send-message --queue-url ${QUEUE_ENDPOINT}  --message-body "Information about the largest city in Any Region."
# Main

get_temp_credential
[ $? -eq 0 ] || exit 1

#download_inventory_list ${INVENTORY_DIR}
[ $? -eq 0 ] || exit 1

#download_inventory_files

[ $? -eq 0 ] || exit 1

#send_files_to_sqs
unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
send_files_to_sqs_python

exit 0
