# 目标
AWS北京区域: [Amzone EMR](http://docs.aws.amazon.com/zh_cn/emr/latest/ManagementGuide/emr-what-is-emr.html) 调度探索: 
 - [EMR steps](http://docs.aws.amazon.com/zh_cn/emr/latest/ManagementGuide/emr-overview.html#emr-work-cluster)
 - [Oozie](http://oozie.apache.org/)
 - [Airflow](https://airflow.incubator.apache.org/)

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
 - [ ] Airflow实现
 - [X] [在群集外创建 Hive 元数据仓](http://docs.aws.amazon.com/zh_cn/emr/latest/ReleaseGuide/emr-dev-create-metastore-outside.html)
 - [ ] [BootStraps创建引导操作以安装其他软件](http://docs.aws.amazon.com/zh_cn/emr/latest/DeveloperGuide/emr-plan-bootstrap.html)
 - [X] 定义日常操作流程

## 业务场景
- 查询数据库中表employees中，1990-01-01以后入职的男女数量
  - 数据库数据
```Bash
mysql> select count(*) from employees;
+----------+
| count(*) |
+----------+
|   300024 |
+----------+
1 row in set (0.04 sec)

mysql> select * from employees limit 10;
+--------+------------+------------+-----------+--------+------------+
| emp_no | birth_date | first_name | last_name | gender | hire_date  |
+--------+------------+------------+-----------+--------+------------+
|  10001 | 1953-09-02 | Georgi     | Facello   | M      | 1986-06-26 |
|  10002 | 1964-06-02 | Bezalel    | Simmel    | F      | 1985-11-21 |
|  10003 | 1959-12-03 | Parto      | Bamford   | M      | 1986-08-28 |
|  10004 | 1954-05-01 | Chirstian  | Koblick   | M      | 1986-12-01 |
|  10005 | 1955-01-21 | Kyoichi    | Maliniak  | M      | 1989-09-12 |
|  10006 | 1953-04-20 | Anneke     | Preusig   | F      | 1989-06-02 |
|  10007 | 1957-05-23 | Tzvetan    | Zielinski | F      | 1989-02-10 |
|  10008 | 1958-02-19 | Saniya     | Kalloufi  | M      | 1994-09-15 |
|  10009 | 1952-04-19 | Sumant     | Peac      | F      | 1985-02-18 |
|  10010 | 1963-06-01 | Duangkaew  | Piveteau  | F      | 1989-08-24 |
+--------+------------+------------+-----------+--------+------------+
10 rows in set (0.00 sec)

mysql> select gender,count(*) from employees group by gender;
+--------+----------+
| gender | count(*) |
+--------+----------+
| M      |   179973 |
| F      |   120051 |
+--------+----------+
2 rows in set (0.14 sec)

mysql> select gender,count(*) from employees where hire_date > '1990-01-01' group by gender;
+--------+----------+
| gender | count(*) |
+--------+----------+
| M      |    81350 |
| F      |    53812 |
+--------+----------+
2 rows in set (0.12 sec)

```

  - 目标数据库中结果集数据
```Bash
mysql> select * from sample_result;
+--------+-------+
| gender | count |
+--------+-------+
| F      | 53812 |
| M      | 81350 |
+--------+-------+
2 rows in set (0.00 sec)
```

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

2. 监控
 - [查看 Amazon EMR 群集上托管的 Web 界面](http://docs.aws.amazon.com/zh_cn/emr/latest/ManagementGuide/emr-web-interfaces.html)
   - [使用动态端口转发设置到主节点的 SSH 隧道](http://docs.aws.amazon.com/zh_cn/emr/latest/ManagementGuide/emr-ssh-tunnel.html)
   - [配置代理设置以查看主节点上托管的网站](http://docs.aws.amazon.com/zh_cn/emr/latest/ManagementGuide/emr-connect-master-node-proxy.html)
   - 使用控制台访问主节点上的 Web 界面
```Bash
接口的名称           URI
YARN ResourceManager http://master-public-dns-name:8088/ 
YARN NodeManager     http://slave-public-dns-name:8042/ 
Hadoop HDFS NameNode http://master-public-dns-name:50070/ 
Hadoop HDFS DataNode http://slave-public-dns-name:50075/ 
Spark HistoryServer  http://master-public-dns-name:18080/ 
Zeppelin             http://master-public-dns-name:8890/ 
Hue                  http://master-public-dns-name:8888/ 
Ganglia              http://master-public-dns-name/ganglia/ 
HBase UI             http://master-public-dns-name:16010/ 
```

# 注意
1. 实际使用中，请大量修改脚本中的常量定义，还未参数话(TODO)
