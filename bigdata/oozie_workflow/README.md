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
 - [ ] [BootStraps创建引导操作以安装其他软件](http://docs.aws.amazon.com/zh_cn/emr/latest/DeveloperGuide/emr-plan-bootstrap.html)
 - [ ] 定义日常操作流程


# 文件说明
 - upload.sh: 将工作文件上传S3,供EMR任务调度使用 
 - emr_create_cluster.sh: 在指定VPC自网内建立Amazon EMR集群, 并将Hive元数据仓库指定为独立RDS Mysql服务
 - emr_add_steps.sh: 选取当前唯一活跃状态的EMR集群，并提交3个步骤
 - mysqltos3.sh: 将RDS中的数据使用sqoop抽取到S3
 - hivetables.q: 定义Hive外表结构，并完成业务逻辑定义
 - s3tomysql.sh: 将S3生成的结果数据使用sqoop重新传入RDS mysql
 - script-runner.jar: [在群集中运行脚本](http://docs.aws.amazon.com/zh_cn/emr/latest/ReleaseGuide/emr-hadoop-script.html), 来源于 s3://cn-north-1.elasticmapreduce/libs/script-runner/script-runner.jar

# 日常操作流程
1. 增加新的内容
 - EMR Steps
  - 定义新的抽取方式, mysqltos3.sh
  - 定义新的业务SQL逻辑, hivetables.q
  - 定义数据导回方式, s3tomysql.sh
  - 运行 ./upload.sh 讲新的脚本上传S3工作目录
  - 运行 ./emr_add_steps.sh 提交任务
  - RDS mysql 中检查结果

2. 监控[TODO]
