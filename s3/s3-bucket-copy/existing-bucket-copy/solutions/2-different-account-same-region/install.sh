#!/bin/bash


DST=/data/s3-copy


[ -d $DST ] || mkdir -p $DST


SRC="check_sqs_list.py  check_sqs_once.sh  check_sqs.sh  read_sqs.sh  s3_check.sh  s3_copy_from_sqs.py  start_read_sqs.sh  sync_down.sh  sync_up.sh"
SRC="$SRC s3_copy_from_inventory.sh inventory_files_to_sqs.py"

install -v $SRC $DST


exit 0

