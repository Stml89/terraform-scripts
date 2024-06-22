import boto3
import os


region = os.environ.get("REGION")
instances = [os.environ.get("INSTANCE_ID")]
ec2 = boto3.client('ec2', region_name=region)


def lambda_handler(event, context):
    ec2.start_instances(InstanceIds=instances)
    print('Started your instances: ' + str(instances))

