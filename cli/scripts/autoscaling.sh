#!/bin/bash

# List with query
aws autoscaling describe-auto-scaling-groups --query 'AutoScalingGroups[*].{GroupName:AutoScalingGroupName, DesiredCapacity:DesiredCapacity}'


# List scheduled-actions
aws autoscaling describe-scheduled-actions

# Add scheduled-actions
aws autoscaling put-scheduled-update-group-action --auto-scaling-group-name testScheduleGroup  \
	--scheduled-action-name sampleScale  \
	--start-time "2015-05-19T12:01:00Z"  \
	--end-time "2015-05-19T12:10:00Z"  \
	--min-size 2  \
	--max-size 6 \
	--desired-capacity 4 

# recurrence
aws autoscaling put-scheduled-update-group-action --auto-scaling-group-name testScheduleGroup --scheduled-action-name recurrenceScaleUpSample  --recurrence "48 11 * * *" --min-size 2 --max-size 6 --desired-capacity 4
aws autoscaling put-scheduled-update-group-action --auto-scaling-group-name testScheduleGroup --scheduled-action-name recurrenceScaleDownSample  --recurrence "52 11 * * *" --min-size 2 --max-size 6 --desired-capacity 3

# Delete scheduled-actions
aws autoscaling delete-scheduled-action --auto-scaling-group-name testScheduleGroup
