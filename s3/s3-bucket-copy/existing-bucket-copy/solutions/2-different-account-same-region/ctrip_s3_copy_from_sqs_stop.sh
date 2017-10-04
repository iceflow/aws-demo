#!/bin/bash

SRV=/data/s3-copy/ctrip_s3_copy_from_sqs.py

app_stop()
{
    APP=$1
    echo "Stopping $APP"

    ID=`ps aux|grep $APP | grep -v grep | awk '{print $2}' | xargs`
    [ "_$ID" != "_" ] && echo "....stopping " && kill $ID
    echo "$APP ....stopped."

}



app_stop $SRV




exit 0
