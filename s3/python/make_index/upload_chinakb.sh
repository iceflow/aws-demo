#!/bin/bash

# http://leopublic.s3-website.cn-north-1.amazonaws.com.cn
# https://s3.cn-north-1.amazonaws.com.cn/leopublic/reInvent2015/Architecture/AWS+re_Invent+2015+_+(ARC302)+Running+Lean+Architectures_+Optimizing+for+Cost+Efficiency+-+YouTube+%5B720p%5D.mp4

D=reinvent

./make_index_chinakb.py

cp index.html.head index.html
cat index.html.td >> index.html
cat index.html.tail >> index.html

[ -f index.html ] && aws s3 cp index.html s3://$D



PUBLIC_KEYS="index.html js/bootstrap.js js/bootstrap.min.js js/npm.js fonts/glyphicons-halflings-regular.eot fonts/glyphicons-halflings-regular.svg fonts/glyphicons-halflings-regular.ttf fonts/glyphicons-halflings-regular.woff fonts/glyphicons-halflings-regular.woff2 css/bootstrap-theme.css css/bootstrap-theme.css.map css/bootstrap-theme.min.css css/bootstrap.css css/bootstrap.css.map css/bootstrap.min.css"

for KEY in ${PUBLIC_KEYS}; do
	aws s3api put-object-acl --bucket $D --key $KEY --grant-read 'uri="http://acs.amazonaws.com/groups/global/AllUsers"'
done
