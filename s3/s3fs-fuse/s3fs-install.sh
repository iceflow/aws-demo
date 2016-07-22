#!/bin/bash
DIR=s3fs-fuse

err_quit()
{
	echo "ERR_QUIT: $1"
	exit 1
}


# 1. Dependencies
sudo yum install -y fuse-devel libcurl-devel libxml2-devel openssl-devel git

# 2 Download source
[ -d $DIR ] && rm -fr $DIR

git clone https://github.com/s3fs-fuse/s3fs-fuse.git

[ -d "$DIR" ] || err_quit "Missing $DIR"

# 3. Build & Install
pushd s3fs-fuse
# For BJS use only, you need to patch. Uncomment it when you want to use in BJS
#wget https://s3.cn-north-1.amazonaws.com.cn/leoawsdemo/s3/s3fs-fuse/s3fs-fuse-bjs.patch
#[ -f s3fs-fuse-bjs.patch ] && patch -p1 < s3fs-fuse-bjs.patch


[ -f configure ] || ./autogen.sh

./configure --prefix=/usr && make && sudo make install

popd

exit 0
