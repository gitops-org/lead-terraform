import boto3

def ebs_volume_cleanup(event, context):
    my_session = boto3.session.Session()
    my_region = my_session.region_name
    ec2 = boto3.resource('ec2', region_name=$my_region)
    volumes = ec2.volumes.all() # If you want to list out all volumes
    volumes = ec2.volumes.filter(Filters=[{'Name': 'status', 'Values': ['available']}]
    volumes_to_delete = list()
    #TODO: can we get date last attached?
    for volume in volumes:
        if len(volume['Attachments']) == 0:
                volumes_to_delete.append(volume['VolumeId'])
                print('Volume ' + volume + ' selected for deletion')

    #for volume in volumes_to_delete:
    #    response = client.delete_volume(
    #        VolumeId='vol-049df61146c4d7901',
    #    )
    #    print('Volume ' + volume + ' deletion requestion response: ' + response)
