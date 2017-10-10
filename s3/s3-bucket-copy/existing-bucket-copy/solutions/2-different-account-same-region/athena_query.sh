#!/bin/bash


rm -fr athena_result && mkdir athena_result


## Find lost
aws --region eu-west-1 athena start-query-execution \
    --query-execution-context Database="inventory_files" \
    --result-configuration OutputLocation="s3://leo-aws-inventory-ireland/athena_result/" \
    --query-string  "
SELECT key
FROM
inventory_files where key NOT IN (select key from inventory_files_copied_20171004);"


## Find difference
aws --region eu-west-1 athena start-query-execution \
    --query-execution-context Database="inventory_files" \
    --result-configuration OutputLocation="s3://leo-aws-inventory-ireland/athena_result/" \
    --query-string  "
SELECT dst.key
FROM
inventory_files_copied_20171004 dst
JOIN inventory_files src ON dst.key = src.key
WHERE
dst.size <> src.size OR dst.etag <> src.etag"

#aws s3 sync s3://leo-aws-inventory-ireland/athena_result/ athena_result/
