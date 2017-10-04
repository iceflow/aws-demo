#!/bin/bash

ORIG_INVENTORY_DIR=inventory_files
COPIED_INVENTORY_DIR=inventory_files_copied

S3_OBJECT_VERIFY_PY=./s3_object_verify.py

function load_object_from_inventory_dir_into_redis()
{
    DIR=$1
    [ -d $DIR ] || return 1

    for F in $DIR/*; do
        echo "Parsing $F..."

        ${S3_OBJECT_VERIFY_PY} load_origin_object_list $F
    done

    return 0
}

function check_not_exist_object_from()
{
    echo "check_not_exist_object_from"
    DIR=$1
    [ -d $DIR ] || return 1



    for F in $DIR/*; do
        echo "Parsing $F..."

        ${S3_OBJECT_VERIFY_PY} check_file_existence_with_redis ctripcorp-nephele-file-ireland $F
        
    done

    return 0
}

# Step one, load copied fiels

#load_object_from_inventory_dir_into_redis ${COPIED_INVENTORY_DIR}
check_not_exist_object_from  ${ORIG_INVENTORY_DIR} check_file_existence_with_redis

exit 0
