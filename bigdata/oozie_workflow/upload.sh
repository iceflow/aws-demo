#!/bin/bash


C_DIR=$(pwd)

D_DIR=s3://leotest/bigdata/oozie_workflow/code

aws s3 sync ${C_DIR} ${D_DIR}
