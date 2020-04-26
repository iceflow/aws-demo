# ref: https://aws.amazon.com/cn/blogs/developer/aws-cli-v2-docker-image/

docker run --rm -it amazon/aws-cli --version

docker run --rm -ti -v ~/.aws:/root/.aws amazon/aws-cli s3 ls


# update
docker pull amazon/aws-cli:latest


# Alias
alias aws='docker run --rm -ti -v ~/.aws:/root/.aws -v $(pwd):/aws amazon/aws-cli'
