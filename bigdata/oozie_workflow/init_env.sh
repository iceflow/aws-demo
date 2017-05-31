#!/bin/bash


aws s3 ls s3://leotest/bigdata/oozie_workflow/

aws s3 rm s3://leotest/bigdata/oozie_workflow/stage_inputfiles/ --recursive
aws s3 rm s3://leotest/bigdata/oozie_workflow/stage_outputfiles/ --recursive


exit 0
