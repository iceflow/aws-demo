# https://docs.aws.amazon.com/cli/latest/reference/ecr/index.html


aws ecr describe-repositories

aws ecr list-images --repository-name c9-ide




# Source Repository permission
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "AllowPull",
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability"
      ]
    }
  ]
}

# Using account user/role have ecr permission

# 
$(aws ecr get-login --region cn-northwest-1 --registry-ids 358620020600 --no-include-email)

docker pull 358620020600.dkr.ecr.cn-northwest-1.amazonaws.com.cn/c9-ide:aws
