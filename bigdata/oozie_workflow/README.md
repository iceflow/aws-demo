

＃目标
AWS北京区域: [Amzone EMR](http://docs.aws.amazon.com/zh_cn/emr/latest/ManagementGuide/emr-what-is-emr.html) 调度探索: 
 - [EMR steps](http://docs.aws.amazon.com/zh_cn/emr/latest/ManagementGuide/emr-overview.html#emr-work-cluster)
 - [Oozie](http://oozie.apache.org/)
 - [Aireflow](https://airflow.incubator.apache.org/)

框架目标完成:
1. [ ] 使用sqoop, EMR Cluster 从RDS mysql 数据库中抽取数据, 存入S3
2. [ ] 使用Hive, 建立外表，结合业务逻辑，生成新的结果集合，结果直接存放在S3上
3. [ ] 使用sqoop, EMR Cluster讲S3数据重新导回RDS mysql
4. [ ] BI直接使用数据库展示

# 1. 框架： 1） mysql -> 抽出来 －> 2） Hive :  

1. ［x] RDS mysql sample data
    * https://dev.mysql.com/doc/employee/en/
    * https://github.com/datacharmer/test_db
2. [x] mysql sqoop to s3
3. EMR : Hive -> result to S3
4. Orchestrated by OOzie  ( Airflow ?? ) 
5. BootStraps 
6. User interfaces:  How to easily build daily workflow  




# 文件说明




Mysql Sample DB:
https://github.com/datacharmer/test_db
mysql -hpoc-public-rds-mysql.cuivkfbunaay.rds.cn-north-1.amazonaws.com.cn -uadmin -p*





Hive:
 s3://leotest/emr/hive/sample-data/UserRecords.txt
