#!/bin/bash

./s3-stat.sh > s3-list.stat

sort -nr -k4 s3-list.stat | grep -v None | awk '{print $4,$1,$8}'

exit 0
