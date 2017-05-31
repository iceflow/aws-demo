

--create a distribution table that used to do analysis.
--$DISDIR is the file locations of this table. such as, s3://cloudfrontloglckjdist2/logs, do not add / in the end.

--drop table employees_sample;
--drop table sample_result;


CREATE EXTERNAL TABLE IF NOT EXISTS employees_sample (
	emp_no  INT,
	birth_date Date,
	first_name STRING,
	last_name  STRING,
	gender char(1),
	hire_date Date
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION 's3://leotest/bigdata/oozie_workflow/stage_inputfiles/employees_sample/';

CREATE EXTERNAL TABLE IF NOT EXISTS employees_selected (
	emp_no  INT,
	birth_date Date,
	first_name STRING,
	last_name  STRING,
	gender char(1),
	hire_date Date
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION 's3://leotest/bigdata/oozie_workflow/stage_outputfiles/employees_selected/';

CREATE EXTERNAL TABLE IF NOT EXISTS sample_result (
	gender char(1),
	count  INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION 's3://leotest/bigdata/oozie_workflow/stage_outputfiles/sample_result/';

--insert into talbe.
INSERT INTO TABLE sample_result
select gender,count(*) as sum from employees_sample where hire_date > '1990-01-01' group by gender;


--delete the semployees_sample taging table
--DROP TABLE cloudfrontlogstaging${DATE};
