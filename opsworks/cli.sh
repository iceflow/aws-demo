aws opsworks describe-stacks
aws opsworks describe-deployments --stack-id 4d7d5faf-9b23-4e1d-bcf7-a1bc672a6758
aws opsworks describe-apps --stack-id 4d7d5faf-9b23-4e1d-bcf7-a1bc672a6758


aws opsworks --region us-east-1 create-app --stack-id 4d7d5faf-9b23-4e1d-bcf7-a1bc672a6758 --name updateApp --type php --app-source Type=git,Url=git://github.com//opsworks-demo-php-simple-app.git,Revision=version1

aws opsworks --region us-east-1 create-deployment --stack-id 4d7d5faf-9b23-4e1d-bcf7-a1bc672a6758  --app-id 2d4ab16a-43e7-41f4-863a-2e0011e7b14f --command "{\"Name\":\"deploy\"}"
