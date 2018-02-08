#!/bin/bash



s3-stat.sh > s3-list.stat

sort -nr -k3 s3-list.stat | grep -v None | awk '{print $3/1024/1024/1024,$1}'

exit 0
