#/bin/bash

INVENTORY_BUCKET=joyou-inventory-list
INVENTORY_DIR=s3://${INVENTORY_BUCKET}/ctripcorp-nephele-file-eu/ctripcore-all/2017-09-19T00-08Z

function get_temp_credential() {
    #arn:aws:iam::064838511194:role/get-s3-inventory-list-role

    TEMP_CREDENTIAL_FILE='/tmp/temp.credential'

    aws --profile default sts assume-role --role-arn arn:aws:iam::064838511194:role/get-s3-inventory-list-role --role-session-name test --output json > ${TEMP_CREDENTIAL_FILE}

    export AWS_ACCESS_KEY_ID=$(cat ${TEMP_CREDENTIAL_FILE} | jq ".Credentials.AccessKeyId"|cut -d\" -f2)
    export AWS_SECRET_ACCESS_KEY=$(cat ${TEMP_CREDENTIAL_FILE} | jq ".Credentials.SecretAccessKey"|cut -d\" -f2)
    export AWS_SESSION_TOKEN=$(cat ${TEMP_CREDENTIAL_FILE} | jq ".Credentials.SessionToken"|cut -d\" -f2)

    [ -f ${TEMP_CREDENTIAL_FILE} ] && rm -f ${TEMP_CREDENTIAL_FILE}
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

}


function download_inventory_files() {
    LOCAL_INVENTORY_DIR=inventory_files

    [ -d ${LOCAL_INVENTORY_DIR} ] || mkdir -p ${LOCAL_INVENTORY_DIR}
    
    FILES=`cat manifest.json | jq ".files[].key"` 

    for F in $FILES; do
        KEY=`echo $F|cut -d\" -f2`
        eval "aws s3 cp s3://${INVENTORY_BUCKET}/$KEY ${LOCAL_INVENTORY_DIR}/"
    done


}

# Main

get_temp_credential

download_inventory_list ${INVENTORY_DIR}

download_inventory_files

exit 0
