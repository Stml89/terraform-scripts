## Create an empty EC2 instance.
File location "create_ec2/create_ec2_t2micro.tf":
- ami_id
- key_name
- vpc_id

## Schedule EC2 start\stop by lambda via EventBridge.
File location "start-stop-ec2-be-schedule/create_iam_lambdas_start_stop.tf:
- region
- instance_id


##### Region and instance_id should be added to ENV variables

## Commands to execute:
- terraform init
- terraform validate
- terraform plan
- terraform apply

Clean up:
- terraform destroy
