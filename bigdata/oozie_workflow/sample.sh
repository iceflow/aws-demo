

# RDS

# Target 
CREATE TABLE employees_selected (
    emp_no      INT             NOT NULL,
    birth_date  DATE            NOT NULL,
    first_name  VARCHAR(14)     NOT NULL,
    last_name   VARCHAR(16)     NOT NULL,
    gender      ENUM ('M','F')  NOT NULL,
    hire_date   DATE            NOT NULL,
    PRIMARY KEY (emp_no)
);

CREATE TABLE employees_sample (
    emp_no      INT             NOT NULL,
    birth_date  DATE            NOT NULL,
    first_name  VARCHAR(14)     NOT NULL,
    last_name   VARCHAR(16)     NOT NULL,
    gender      ENUM ('M','F')  NOT NULL,
    hire_date   DATE            NOT NULL,
    PRIMARY KEY (emp_no)
);

mysql> INSERT INTO employees_sample from select * from  employees_sample limit 10;


CREATE TABLE departments_result (
    dept_no     CHAR(4)         NOT NULL,
    dept_name   VARCHAR(40)     NOT NULL,
    PRIMARY KEY (dept_no),
    UNIQUE  KEY (dept_name)
);

CREATE TABLE sample_result (
    gender      ENUM ('M','F')  NOT NULL,
    count		INT            NOT NULL
);

# Client
ssh -i ~/poc.pem -ND 8157 hadoop@ec2-54-222-191-246.cn-north-1.compute.amazonaws.com.cn


# Sqoop : http://www.linuxidc.com/Linux/2013-06/85817.htm


HOSTNAME=poc-public-rds-mysql.cuivkfbunaay.rds.cn-north-1.amazonaws.com.cn
DB=employees
TABLE=departments
TARGET_DIR=s3://leotest/bigdata/oozie_workflow/stage_inputfiles
#TARGET_DIR=test
EXPORT_DIR=results

USERNAME=admin
PASSWORD=xxxxx

#aws s3 rm s3://leotest/bigdata/oozie_workflow/stage_inputfiles/ --recursive

sqoop import --connect jdbc:mysql://$HOSTNAME:3306/$DB --table $TABLE --username $USERNAME --password $PASSWORD --target-dir ${TARGET_DIR}/$TABLE
#sqoop import-all-tables --connect jdbc:mysql://$HOSTNAME:3306/$DB --username $USERNAME --password $PASSWORD --target-dir ${TARGET_DIR}
#sqoop list-tables --connect jdbc:mysql://$HOSTNAME:3306/$DB --username $USERNAME --password $PASSWORD

#aws s3 rm s3://leotest/bigdata/oozie_workflow/stage_outputfiles/ --recursive

# s3tomysql.sh
SQOOPFILEBUCKET=s3://leotest/bigdata/oozie_workflow/stage_outputfiles/departments/
TARGET_TABLE=departments_result

sqoop export --connect $JDBCURL --username $USERNAME --password $PASSWORD --table ${TARGET_TABLE} --fields-terminated-by ',' --export-dir s3://$SQOOPFILEBUCKET


创建一个名为 hiveConfiguration.json 的配置文件，其中包含对 hive-site.xml 的编辑： 
# 创建带有参数修改的集群
aws emr create-cluster --release-label emr-5.3.0 --instance-type m3.xlarge --instance-count 2 \
--applications Name=Hive --configurations ./hiveConfiguration.json --use-default-roles


# Hive
create external table IF NOT EXISTS departments(
	dept_no VARCHAR(4),
	dept_name VARCHAR(40)
 )
     ROW FORMAT DELIMITED
     FIELDS TERMINATED BY ','
     LINES TERMINATED BY '\n'
     STORED AS TEXTFILE
     LOCATION 's3://leotest/bigdata/oozie_workflow/stage_inputfiles/departments/';

create table IF NOT EXISTS departments_result(
	dept_no VARCHAR(4),
	dept_name VARCHAR(40)
 )
     LOCATION 's3://leotest/bigdata/oozie_workflow/stage_outputfiles/departments/';

--insert into talbe.
INSERT INTO TABLE departments_result 
SELECT dept_no, dept_name FROM departments limit 3;

## employees
create external table IF NOT EXISTS departments(
    dept_no VARCHAR(4),
    dept_name VARCHAR(40)
 )
     ROW FORMAT DELIMITED
     FIELDS TERMINATED BY ','
     LINES TERMINATED BY '\n'
     STORED AS TEXTFILE
     LOCATION 's3://leotest/bigdata/oozie_workflow/stage_inputfiles/departments/';



