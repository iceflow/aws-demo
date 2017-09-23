#!/bin/bash



aws s3 ls s3://ireland-leo-test/ --recursive | wc -l


exit 0
