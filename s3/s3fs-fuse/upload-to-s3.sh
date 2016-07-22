#!/bin/bash

aws s3 cp . s3://leoawsdemo/s3/s3fs-fuse/ --recursive
