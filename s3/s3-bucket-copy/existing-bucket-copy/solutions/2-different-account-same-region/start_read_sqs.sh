#!/bin/bash

TOP=${1:-10}


N=1


CMD=/data/s3-copy/read_sqs.sh

while [ 1 ]; do
        [ $N -gt $TOP ] && break

        $CMD

        let N=$N+1

done

echo "Start $TOP $CMD done."

exit 0
