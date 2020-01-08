import boto3

regions_name=['cn-northwest-1', 'cn-north-1']

# autostart filter
start_filter = [
    {'Name': 'tag:AutoStart', 'Values': ['true', 'True', 'TRUE']},
    {'Name': 'instance-state-name', 'Values': ['stopped']}
]

def regional_start_ec2(region_name='cn-northwest-1'):
    print("Auto Start EC2 in region {}".format(region_name))
    
    # the ec2 resource
    ec2 = boto3.resource('ec2', region_name=region_name)
    
    # get list of filtered instances
    instances = ec2.instances.filter(Filters=start_filter)
    
    # get instance id list
    filtered_ids = [instance.id for instance in instances]
    
    # verify there are instances to start
    if len(filtered_ids) > 0:
        print("AutoStart Instances:{}".format(filtered_ids))
        start_message = instances.start()
        print("Start Response:{}".format(start_message))
    else:
        print("No EC2 instances found to start")
    

def lambda_handler(event, context):
    for region in regions_name:
        regional_start_ec2(region)

    print('Auto Start EC2 Done')
