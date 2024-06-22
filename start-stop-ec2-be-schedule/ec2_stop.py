import boto3
import os



region = os.environ['REGION']
instances = [os.environ['INSTANCE_ID']]
ec2 = boto3.client('ec2', region_name=region)


def lambda_handler(event, context):
    ec2.stop_instances(InstanceIds=instances)
    print('Stopped your instances: ' + str(instances))
