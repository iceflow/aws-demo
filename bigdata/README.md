

# [flink]
NYC taxi stream data to kinesise -> Flink on EMR
https://aws.amazon.com/cn/blogs/big-data/build-a-real-time-stream-processing-pipeline-with-apache-flink-on-aws/#more-2104

# [ oozie_workflow ]
##  PoC  
oozie: 调度
# 1. 框架： 1） mysql -> 抽出来 －> 2） Hive :  
1. ［x] RDS mysql sample data
    * https://dev.mysql.com/doc/employee/en/
    * https://github.com/datacharmer/test_db
2. [x] mysql sqoop to s3
3. EMR : Hive -> result to S3
4. Orchestrated by OOzie  ( Airflow ?? ) 
5. BootStraps 
6. User interfaces:  How to easily build daily workflow  
7. Steps submit
8. Oozie way
9. Other better way

# [flowlog-analysis]
Try to analyze flowlog data and extract top 5 inbount+outbound internal hosts



s3://cn-north-1.elasticmapreduce/
