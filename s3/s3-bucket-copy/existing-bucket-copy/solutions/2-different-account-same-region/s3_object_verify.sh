#!/bin/bash

SRC_INVENTORY_DIR=inventory_files
DST_INVENTORY_DIR=inventory_files_copied


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



function check_not_exist_object()
{
    return 0
}




# Step one, load copied fiels

load_object_from_inventory_dir_into_redis ${DST_INVENTORY_DIR}
