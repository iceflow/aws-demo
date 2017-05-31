#!/bin/bash

HOSTNAME=poc-public-rds-mysql.cuivkfbunaay.rds.cn-north-1.amazonaws.com.cn
DB=employees
TABLE=employees
TARGET_DIR=s3://leotest/bigdata/oozie_workflow/stage_inputfiles

USERNAME=admin
PASSWORD=xxxxxx

JDBCURL=jdbc:mysql://$HOSTNAME:3306/$DB

sqoop import --connect $JDBCURL --table $TABLE --username $USERNAME --password $PASSWORD --target-dir ${TARGET_DIR}/$TABLE

exit 0
