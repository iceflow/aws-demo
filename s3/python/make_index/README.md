# 简介

由于S3支持H.264，AAC格式自动stream, 特别适合点播，只要网速正常，可以随时在线查看。免去下载。

1. 启用bucket webhosting

2. 自动生成index.html页面

3. bootstrap web模版

# 文件说明

make_index.py: 

	1. 使用python boto3

	2. 使用 aws configure 配置credential

	3. 遍历选定Bucket下的对象, 带过滤

	4. 生成下载文件列表 html-<tr>部分

	5. 遍历对象，增加 public read 权限

upload.sh

	1. 运行 make_index.py

	2. 合并生成index.html

	3. 上传到目标bucket


# 使用方法:

./upload.sh  # 遍历目标Bucket内容，生成 index.html文件，上传到目标bucket

修改: make_index.py 中的

BUCKET_NAME='leopublic'

PREFIX='reInvent2015/'

INDEX_FILE='index.html.td'

来匹配自己的环境

# 参考

Boto3

源码:        https://github.com/boto/boto3

快速入门:    https://boto3.readthedocs.org/en/latest/guide/quickstart.html

API参考:     https://boto3.readthedocs.org/en/latest/reference/services/index.html

# TODO

配置文件独立


