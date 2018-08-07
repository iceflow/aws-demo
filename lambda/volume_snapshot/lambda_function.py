import boto3

regions_name=['cn-northwest-1', 'cn-north-1']


def get_snapshot_volues(region_name='cn-northwest-1'):
    client = boto3.client('ec2', region_name=region_name)
    responses = client.describe_volumes(
        Filters=[
            {
                'Name': 'tag:NeedSnapshot',
                'Values': [
                    'yes'
                ]
            }
        ]
    )
    volumes=[]
    for item in responses['Volumes']:
        volumes.append(item['VolumeId'])

    return volumes


def region_volume_snapshot(region_name='cn-northwest-1'):
    print("Creating volume snapshot in region {}".format(region_name))
    volumes = get_snapshot_volues(region_name)
    #create_volume_snapshot
    ec2 = boto3.resource('ec2', region_name=region_name)
    for volume_id in volumes:
        volume = ec2.Volume(volume_id)
        snapshot = volume.create_snapshot(Description='Test Create Volume {} Snapshot'.format(volume_id), DryRun=False)
        print(snapshot)    

def lambda_handler(event, context):
    for region in regions_name:
        region_volume_snapshot(region)

    return 'Snapshot Done'
