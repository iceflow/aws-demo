#!/bin/bash

# the dir you put .sh, .jar. hive.q files, *do not* add / in the end.
CODEDIR=s3://leotest/bigdata/oozie_workflow/code

aws emr list-clusters --active --query 'Clusters[].[Id]' --output text

CLUSTER_ID=`aws emr list-clusters --active --query 'Clusters[].[Id]' --output text`

#CLUSTER_ID='j-IZD9CMV8GNV8'

DISDIR=s3://leotest/bigdata/oozie_workflow

aws emr add-steps --cluster-id ${CLUSTER_ID} --steps \
Type=CUSTOM_JAR,Name="init_env",Jar=$CODEDIR/script-runner.jar,Args=["$CODEDIR/init_env.sh"] \
Type=CUSTOM_JAR,Name="mysqltos3",Jar=$CODEDIR/script-runner.jar,Args=["$CODEDIR/mysqltos3.sh"] \
Type=Hive,Name="HiveStep",Args=[-f,$CODEDIR/hivetables.q,-d,DISDIR=$DISDIR]  \
Type=CUSTOM_JAR,Name="s3tomysql",Jar=$CODEDIR/script-runner.jar,Args=["$CODEDIR/s3tomysql.sh"]


#Type=CUSTOM_JAR,Name="cpjar",Jar=$CODEDIR/script-runner.jar,Args=["$CODEDIR/cpjar.sh","$CODEDIR"] \
#Type=CUSTOM_JAR,Name="log2staging",Jar=$CODEDIR/script-runner.jar,Args=["$CODEDIR/log2staging.sh","$LOGSOURCEDIR","$STAGINGDIR","$DATE","$DATEE"] \
#Type=CUSTOM_JAR,Name="Presto2s3",Jar=$CODEDIR/script-runner.jar,Args=["$CODEDIR/presto2s3.sh","$SQOOPFILEBUCKET","$DATE","$DATEE"] \
