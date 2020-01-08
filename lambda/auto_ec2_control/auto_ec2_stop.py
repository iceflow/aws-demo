import boto3

regions_name=['cn-northwest-1', 'cn-north-1']

# autostop filter
stop_filter = [
    {'Name': 'tag:AutoStop', 'Values': ['true', 'True', 'TRUE']},
    {'Name': 'instance-state-name', 'Values': ['running']}
]

def regional_stop_ec2(region_name='cn-northwest-1'):
    print("Auto Stop EC2 in region {}".format(region_name))
    
    # the ec2 resource
    ec2 = boto3.resource('ec2', region_name=region_name)
    
    # get list of filtered instances
    instances = ec2.instances.filter(Filters=stop_filter)
    
    # get instance id list
    filtered_ids = [instance.id for instance in instances]
    
    # verify there are instances to stop
    if len(filtered_ids) > 0:
        print("AutoStop Instances:{}".format(filtered_ids))
        stop_message = instances.stop()
        print("Stop Response:{}".format(stop_message))
    else:
        print("No EC2 instances found to stop")
    

def lambda_handler(event, context):
    for region in regions_name:
        regional_stop_ec2(region)

    print('Auto Stop EC2 Done')
