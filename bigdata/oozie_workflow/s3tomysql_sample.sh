#!/bin/bash

HOSTNAME=poc-public-rds-mysql.cuivkfbunaay.rds.cn-north-1.amazonaws.com.cn
DB=employees
TARGET_TABLE=sample_result
SRC_DIR=s3://leotest/bigdata/oozie_workflow/stage_outputfiles/sample_result/

USERNAME=admin
PASSWORD=xxxxx

JDBCURL=jdbc:mysql://$HOSTNAME:3306/$DB

sqoop export --connect $JDBCURL --username $USERNAME --password $PASSWORD --table ${TARGET_TABLE} --fields-terminated-by ',' --export-dir ${SRC_DIR}

exit 0
