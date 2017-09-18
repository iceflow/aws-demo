#!/bin/bash


CLUSTER_ID=j-2XLXHYEDAMKQJ

#aws emr add-steps --cluster-id ${CLUSTER_ID}  --steps file://./myStep.json
aws emr add-steps --cluster-id ${CLUSTER_ID}  --steps file://./myStepCtrip.json
