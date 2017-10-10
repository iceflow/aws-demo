#!/bin/bash


# Source Sections
SRC_INVENTORY_BUCKET=joyou-inventory-list
SRC_INVENTORY_PREFIX=ctripcorp-nephele-file-eu/ctripcore-all
SRC_INVENTORY_MANIFEST_DATE=2017-10-08T00-09Z
SRC_PROFILE=leo@joyou

SRC_MANIFEST_POS="s3://${SRC_INVENTORY_BUCKET}/${SRC_INVENTORY_PREFIX}/${SRC_INVENTORY_MANIFEST_DATE}"
SRC_MANIFEST_DATA="s3://${SRC_INVENTORY_BUCKET}/${SRC_INVENTORY_PREFIX}/data"


# Destination Sections
DST_INVENTORY_BUCKET=ctripcorp-nephele-tmp-ireland
DST_INVENTORY_PREFIX=ctripcorp-nephele-file-ireland/test
DST_INVENTORY_MANIFEST_DATE=2017-10-07T18-08Z
DST_PROFILE=joyou@ctrip

DST_MANIFEST_POS="s3://${DST_INVENTORY_BUCKET}/${DST_INVENTORY_PREFIX}/${DST_INVENTORY_MANIFEST_DATE}"
DST_MANIFEST_DATA="s3://${DST_INVENTORY_BUCKET}/${DST_INVENTORY_PREFIX}/data"


# Local directory
L_DIR=inventory_comparision


function download_inventory_list() {

    aws --profile $1 s3 cp $2/manifest.json $3/manifest.json
    aws --profile $1 s3 cp $2/manifest.checksum $3/manifest.checksum

    # TODO: Check file integrity
    # md5-check manifest.json manifest.checksum

    return 0
}


function download_inventory_files() {
    PROFILE=$1
    MANIFEST_JSON=$2
    SRC_DIR=$3
    DST_DIR=$4

    [ -d ${DST_DIR} ] || mkdir -p ${DST_DIR}

    FILES=`cat ${MANIFEST_JSON} | jq ".files[].key"` 

    for F in $FILES; do
        KEY=`echo $F|cut -d\" -f2`
        aws --profile ${PROFILE} s3 cp s3://${SRC_DIR}/$KEY ${DST_DIR}/
    done

    return 0
}

# Destination Sections




[ -d ${L_DIR} ] || mkdir -p ${L_DIR}/{src,dst}
# Download SRC
download_inventory_list ${SRC_PROFILE} ${SRC_MANIFEST_POS} ${L_DIR}/src
download_inventory_files ${SRC_PROFILE} ${L_DIR}/src/manifest.json ${SRC_INVENTORY_BUCKET} ${L_DIR}/src/${SRC_INVENTORY_MANIFEST_DATE}

# Download DST
download_inventory_list ${DST_PROFILE} ${DST_MANIFEST_POS} ${L_DIR}/dst
download_inventory_files ${DST_PROFILE} ${L_DIR}/dst/manifest.json ${DST_INVENTORY_BUCKET} ${L_DIR}/dst/${DST_INVENTORY_MANIFEST_DATE}



exit 0
