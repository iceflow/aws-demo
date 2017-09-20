#/bin/bash


#aws --profile leo@joyou s3 ls s3://leo-test-ireland/
#aws --profile leo@joyou s3 cp s3://leo-test-ireland/test.txt .



aws s3 ls s3://joyou-inventory-list/ctripcorp-nephele-file-eu/ctripcore-all/2017-09-19T00-08Z/

aws --profile leo@joyou s3 sync s3://joyou-inventory-list s3://ireland-leo-test/joyou-inventory-list


exit 0
