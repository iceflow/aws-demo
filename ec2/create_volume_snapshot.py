#!/usr/bin/env python
# -*- coding: utf-8 -*-

# refer: https://github.com/evannuil/aws-snapshot-tool


import boto3


#def create_volume_snapshot(volume, desc=None, tag_keyname=None, tag_value=None):


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

def test(region_name='cn-northwest-1'):
    volumes = get_snapshot_volues(region_name)

    #create_volume_snapshot
    ec2 = boto3.resource('ec2', region_name=region_name)

    for volume_id in volumes:
        volume = ec2.Volume(volume_id)
        snapshot = volume.create_snapshot(Description='Test Create Volume {} Snapshot'.format(volume_id), DryRun=False)

        print(snapshot)

if __name__ == '__main__':
    #test(region_name='cn-northwest-1')
    test(region_name='cn-north-1')
