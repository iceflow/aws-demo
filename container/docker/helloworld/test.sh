
docker build -t helloworld .
#docker push

docker image inspect helloworld


docker run -p 4000:80 helloworld python app.py



# Check container ip
docker ps

docker inspect --format '{{ .NetworkSettings.IPAddress }}' f300ca55e48a

docker inspect -f '{{.Name}} - {{.NetworkSettings.IPAddress }}' $(docker ps -aq)


# Dock Hub
docker login -u xxx -pxxx

docker tag helloworld leoflow/helloworld:v1

docker push leoflow/helloworld:v1

# re-attach to running container

docker exec -it {container_id} /bin/bash

docker commit e6999f22f462 leoflow/helloworld:v2

docker push leoflow/helloworld:v2

# Check container pid
docker inspect --format '{{ .State.Pid }}' e6999f22f462

# namespaces
[root@ip-172-31-30-169 helloworld]# docker run -it --net container:e6999f22f462 busybox ifconfig
eth0      Link encap:Ethernet  HWaddr 02:42:AC:11:00:02  
          inet addr:172.17.0.2  Bcast:172.17.255.255  Mask:255.255.0.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:16 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:1256 (1.2 KiB)  TX bytes:0 (0.0 B)

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)



## Volume
#docker run -it -v $PWD:/test --rm busybox
docker run -it -v /test --rm busybox


#### push to ECR cn-northwest-1
# https://docs.amazonaws.cn/en_us/AmazonECR/latest/userguide/ECR_AWSCLI.html
`aws ecr get-login --region cn-northwest-1 --no-include-email`

docker login -u AWS -p xxxx  https://358620020600.dkr.ecr.cn-northwest-1.amazonaws.com.cn

# aws ecr create-repository --repository-name helloworld
{
    "repository": {
        "repositoryArn": "arn:aws-cn:ecr:cn-northwest-1:358620020600:repository/hellworld",
        "registryId": "358620020600",
        "repositoryName": "hellworld",
        "repositoryUri": "358620020600.dkr.ecr.cn-northwest-1.amazonaws.com.cn/hellworld",
        "createdAt": 1549542868.0
    }
}

docker tag helloworld:v2 358620020600.dkr.ecr.cn-northwest-1.amazonaws.com.cn/hellworld:v2
docker tag leoflow/helloworld:v2 358620020600.dkr.ecr.cn-northwest-1.amazonaws.com.cn/hellworld:v2

docker push 358620020600.dkr.ecr.cn-northwest-1.amazonaws.com.cn/hellworld:v2
