#!/bin/bash


HOSTNAME=poc-public-rds-mysql.cuivkfbunaay.rds.cn-north-1.amazonaws.com.cn
DB=employees
TABLE=employees_sample
TARGET_DIR=s3://leotest/bigdata/oozie_workflow/stage_inputfiles
#TARGET_DIR=test
EXPORT_DIR=results

USERNAME=admin
PASSWORD=xxxxx

JDBCURL=jdbc:mysql://$HOSTNAME:3306/$DB

#aws s3 rm s3://leotest/bigdata/oozie_workflow/stage_inputfiles/ --recursive

#sqoop import --connect jdbc:mysql://$HOSTNAME:3306/$DB --table $TABLE --username $USERNAME --password $PASSWORD --target-dir ${TARGET_DIR}/$TABLE
#sqoop import-all-tables --connect jdbc:mysql://$HOSTNAME:3306/$DB --username $USERNAME --password $PASSWORD --target-dir ${TARGET_DIR}
#sqoop list-tables --connect jdbc:mysql://$HOSTNAME:3306/$DB --username $USERNAME --password $PASSWORD

#aws s3 rm s3://leotest/bigdata/oozie_workflow/stage_outputfiles/ --recursive

#exit

# s3tomysql.sh
#SQOOPFILEBUCKET=s3://leotest/bigdata/oozie_workflow/stage_outputfiles/departments/
SQOOPFILEBUCKET=s3://leotest/bigdata/oozie_workflow/stage_inputfiles/employees_sample/
TARGET_TABLE=employees_selected

sqoop export --connect $JDBCURL --username $USERNAME --password $PASSWORD --table ${TARGET_TABLE} --fields-terminated-by ',' --export-dir $SQOOPFILEBUCKET
