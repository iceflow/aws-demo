#!/bin/bash


#D=inventory_files
#aws s3 sync $D s3://leo-aws-inventory-ireland/$D


3D=inventory_files_test
3D=inventory_files_dest_test
D=inventory_files_copied_2017-10-04T18-08Z

aws s3 sync $D s3://leo-aws-inventory-ireland/$D

exit 0


CREATE EXTERNAL TABLE IF NOT EXISTS inventory_files.inventory_files (
  `bucket` string,
  `key` string,
  `size` string,
  `lastmodifieddate` string,
  `etag` string,
  `storageclass` string,
  `ismultipartuploaded` string,
  `replicationstatus` string 
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe'
WITH SERDEPROPERTIES (
  'serialization.format' = ',',
  'field.delim' = ','
) LOCATION 's3://leo-aws-inventory-ireland/inventory_files/'
TBLPROPERTIES ('has_encrypted_data'='false');

CREATE EXTERNAL TABLE IF NOT EXISTS inventory_files.inventory_files_copied_20171003 (
  `bucket` string,
  `key` string,
  `size` string,
  `lastmodifieddate` string,
  `etag` string,
  `storageclass` string,
  `ismultipartuploaded` string,
  `replicationstatus` string 
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe'
WITH SERDEPROPERTIES (
  'serialization.format' = ',',
  'field.delim' = ','
) LOCATION 's3://leo-aws-inventory-ireland/inventory_files_copied_2017-10-03T18-09Z/'
TBLPROPERTIES ('has_encrypted_data'='false');


CREATE EXTERNAL TABLE IF NOT EXISTS inventory_files.inventory_files_copied_20171004 (
  `bucket` string,
  `key` string,
  `size` string,
  `lastmodifieddate` string,
  `etag` string,
  `storageclass` string,
  `ismultipartuploaded` string,
  `replicationstatus` string
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe'
WITH SERDEPROPERTIES (
  'serialization.format' = ',',
  'field.delim' = ','
) LOCATION 's3://leo-aws-inventory-ireland/inventory_files_copied_2017-10-04T18-08Z/'
TBLPROPERTIES ('has_encrypted_data'='false');

inventory_files_copied_2017-10-04T18-08Z



CREATE EXTERNAL TABLE IF NOT EXISTS inventory_files.inventory_files_test (
  `bucket` string,
  `key` string,
  `size` string,
  `lastmodifieddate` string,
  `etag` string,
  `storageclass` string,
  `ismultipartuploaded` string,
  `replicationstatus` string 
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe'
WITH SERDEPROPERTIES (
  'serialization.format' = ',',
  'field.delim' = ','
) LOCATION 's3://leo-aws-inventory-ireland/inventory_files_test/'
TBLPROPERTIES ('has_encrypted_data'='false');


CREATE EXTERNAL TABLE IF NOT EXISTS inventory_files.inventory_files_dest_test (
  `bucket` string,
  `key` string,
  `size` string,
  `lastmodifieddate` string,
  `etag` string,
  `storageclass` string,
  `ismultipartuploaded` string,
  `replicationstatus` string 
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe'
WITH SERDEPROPERTIES (
  'serialization.format' = ',',
  'field.delim' = ','
) LOCATION 's3://leo-aws-inventory-ireland/inventory_files_dest_test/'
TBLPROPERTIES ('has_encrypted_data'='false');

CREATE EXTERNAL TABLE IF NOT EXISTS inventory_files.inventory_files_diff (
  `key` string
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe'
WITH SERDEPROPERTIES (
  'serialization.format' = ',',
  'field.delim' = ','
) LOCATION 's3://leo-aws-inventory-ireland/inventory_files_diff/'
TBLPROPERTIES ('has_encrypted_data'='false');




## Find difference
SELECT nt.key,
   CASE WHEN ct.size <> nt.size THEN '--' ELSE  nt.size END,
   CASE WHEN ct.etag <> nt.etag THEN '--' ELSE  nt.etag END
FROM
inventory_files_test nt
JOIN inventory_files_dest_test ct ON nt.key = ct.key
WHERE
ct.size <> nt.size OR ct.etag <> nt.etag

## Find lost
SELECT key into inventory_files_diff
FROM
inventory_files_test where key NOT IN (select key from inventory_files_dest_test);


aws athena create-named-query --name test \
    --database inventory_files \
    --query-string  "
SELECT key into inventory_files_diff 
FROM
inventory_files_test where key NOT IN (select key from inventory_files_dest_test); "
    

inventory_files                     49477961
inventory_files_copied_20171003     40009548
inventory_files_copied_20171004     44640867


SELECT nt.key,
   CASE WHEN ct.size <> nt.size THEN '--' ELSE  nt.size END,
   CASE WHEN ct.etag <> nt.etag THEN '--' ELSE  nt.etag END
FROM
inventory_files_test nt
JOIN inventory_files_dest_test ct ON nt.key = ct.key
WHERE
ct.size <> nt.size OR ct.etag <> nt.etag

## Find lost
SELECT key 
FROM
inventory_files where key NOT IN (select key from inventory_files_copied_20171003);


## Find difference
SELECT dst.key
FROM
inventory_files_copied_20171003 dst
JOIN inventory_files src ON dst.key = src.key
WHERE
dst.size <> src.size OR dst.etag <> src.etag
