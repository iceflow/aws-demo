# 目标
AWS北京区域: [Amzone EMR](http://docs.aws.amazon.com/zh_cn/emr/latest/ManagementGuide/emr-what-is-emr.html) 调度探索: 
 - [EMR steps](http://docs.aws.amazon.com/zh_cn/emr/latest/ManagementGuide/emr-overview.html#emr-work-cluster)
 - [Oozie](http://oozie.apache.org/)
 - [Aireflow](https://airflow.incubator.apache.org/)

## 框架目标完成:
1. [ ] 使用sqoop, EMR Cluster 从RDS mysql 数据库中抽取数据, 存入S3
2. [ ] 使用Hive, 建立外表，结合业务逻辑，生成新的结果集合，结果直接存放在S3上
3. [ ] 使用sqoop, EMR Cluster讲S3数据重新导回RDS mysql
4. [ ] BI直接使用数据库展示

## 任务:
 - [X] RDS mysql 原始数据准备
    * https://dev.mysql.com/doc/employee/en/
    * https://github.com/datacharmer/test_db
 - [X] EMR Steps实现
 - [ ] OOzie实现
 - [ ] Aireflow实现
 - [X] [在群集外创建 Hive 元数据仓](http://docs.aws.amazon.com/zh_cn/emr/latest/ReleaseGuide/emr-dev-create-metastore-outside.html)
 - [ ] BootStraps创建引导操作以安装其他软件(http://docs.aws.amazon.com/zh_cn/emr/latest/DeveloperGuide/emr-plan-bootstrap.html)
 - [ ] User interfaces:  How to easily build daily workflow  



# 文件说明

