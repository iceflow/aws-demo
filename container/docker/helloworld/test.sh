
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

