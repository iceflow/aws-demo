# AWS EBS snapshot lambda function (Tested in AWS Beijing/Ningxia Region)
## Description
Daily backup tagged EBS volumes (creating snapshots) by lambda function.

## Steps
 - 1. Adding Tag(Key=NeedSnapshot,Value=yes) to the EBS volumes which needed automatic backup.
 - 2. Create lambda func volume_snapshot by using lambda_function.py in this directory
 - 3. Create daily cron job by using cloud watch event.
