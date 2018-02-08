#!/bin/bash

# List active clusters
aws emr list-clusters --active


aws emr describe-cluster --cluster-id j-1LDM6LUAODFWC


aws emr add-steps --cluster-id j-3GYXXXXXX9IOK --steps Type=CUSTOM_JAR,Name="S3DistCp step",Jar=/home/hadoop/lib/emr-s3distcp-1.0.jar,\
Args=["--s3Endpoint,s3-eu-west-1.amazonaws.com","--src,s3://mybucket/logs/j-3GYXXXXXX9IOJ/node/","--dest,hdfs:///output","--srcPattern,.*[a-zA-Z,]+"]




aws emr create-cluster --release-label emr-5.3.0 --instance-type m3.xlarge --instance-count 2 --applications Name=Hive --configurations https://s3.amazonaws.com/mybucket/myfolder/myConfig.json



aws emr create-cluster --name "Test cluster" –-release-label emr-5.3.0 --applications Name=Hive Name=Pig --use-default-roles --ec2-attributes KeyName=myKey --instance-type m3.xlarge --instance-count 3 --steps Type=CUSTOM_JAR,Name=CustomJAR,ActionOnFailure=CONTINUE,Jar=s3://region.elasticmapreduce/libs/script-runner/script-runner.jar,Args=["s3://mybucket/script-path/my_script.sh"]

aws emr create-cluster --name "Test cluster" --release-label emr-5.3.0 --applications Name=Hue Name=Hive Name=Pig --use-default-roles \
--ec2-attributes KeyName=myKey --instance-type m3.xlarge --instance-count 3 \
--steps Type=STREAMING,Name="Streaming Program",ActionOnFailure=CONTINUE,Args=[--files,pathtoscripts,-mapper,mapperscript,-reducer,reducerscript,aggregate,-input,pathtoinputdata,-output,pathtooutputbucket]


## Proxy access
# https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-ssh-tunnel.html
#ssh -i ~/mykeypair.pem -N -D 8157 hadoop@ec2-###-##-##-###.compute-1.amazonaws.com

# Then configure to use foxproxy https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-connect-master-node-proxy.html
<?xml version="1.0" encoding="UTF-8"?>
<foxyproxy>
   <proxies>
      <proxy name="emr-socks-proxy" id="2322596116" notes="" fromSubscription="false" enabled="true" mode="manual" selectedTabIndex="2" lastresort="false" animatedIcons="true" includeInCycle="true" color="#0055E5" proxyDNS="true" noInternalIPs="false" autoconfMode="pac" clearCacheBeforeUse="false" disableCache="false" clearCookiesBeforeUse="false" rejectCookies="false">
         <matches>
            <match enabled="true" name="*ec2*.amazonaws.com*" pattern="*ec2*.amazonaws.com*" isRegEx="false" isBlackList="false" isMultiLine="false" caseSensitive="false" fromSubscription="false" />
            <match enabled="true" name="*ec2*.compute*" pattern="*ec2*.compute*" isRegEx="false" isBlackList="false" isMultiLine="false" caseSensitive="false" fromSubscription="false" />
            <match enabled="true" name="10.*" pattern="http://10.*" isRegEx="false" isBlackList="false" isMultiLine="false" caseSensitive="false" fromSubscription="false" />
            <match enabled="true" name="*10*.amazonaws.com*" pattern="*10*.amazonaws.com*" isRegEx="false" isBlackList="false" isMultiLine="false" caseSensitive="false" fromSubscription="false" />
            <match enabled="true" name="*10*.compute*" pattern="*10*.compute*" isRegEx="false" isBlackList="false" isMultiLine="false" caseSensitive="false" fromSubscription="false" /> 
            <match enabled="true" name="*.compute.internal*" pattern="*.compute.internal*" isRegEx="false" isBlackList="false" isMultiLine="false" caseSensitive="false" fromSubscription="false"/>
            <match enabled="true" name="*.ec2.internal* " pattern="*.ec2.internal*" isRegEx="false" isBlackList="false" isMultiLine="false" caseSensitive="false" fromSubscription="false"/>false  
	   </matches>
         <manualconf host="localhost" port="8157" socksversion="5" isSocks="true" username="" password="" domain="" />
      </proxy>
   </proxies>
</foxyproxy>

