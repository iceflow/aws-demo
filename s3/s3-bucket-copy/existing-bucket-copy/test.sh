#/bin/bash


aws --profile leo@joyou s3 ls s3://leo-test-ireland/
aws --profile leo@joyou s3 cp s3://leo-test-ireland/test.txt .

aws --profile leo@joyou s3 sync s3://joyou-inventory-list s3://leo-test-ireland/joyou-inventory-list


exit 0
