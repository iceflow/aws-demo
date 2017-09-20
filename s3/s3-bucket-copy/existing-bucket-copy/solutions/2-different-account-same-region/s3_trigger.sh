#!/bin/bash


aws s3 cp 0022d4cd-3a32-4477-90fb-aee895e8a136.csv.gz s3://ireland-leo-test/test.gz
#aws s3 cp s3://ireland-leo-test/0022d4cd-3a32-4477-90fb-aee895e8a136.csv.gz s3://ireland-leo-test/0022d4cd-3a32-4477-90fb-aee895e8a136.csv.gz


#aws s3 rm s3://ireland-leo-test/test.txt
#aws s3 cp test.txt s3://ireland-leo-test
#aws s3 cp s3://ireland-leo-test/test.txt s3://ireland-leo-test/test.txt


exit 0
