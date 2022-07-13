# 365Scores DevOps Project
## Infrastructure as Code (IAC)
Create the below AWS objects using Terraform (or other IAC tools like
CloudFormation or Ansible) :
* VPC with two public and private subnets
* Route table for each subnet
* Security group that allows ports 80 and 443 from the internet
* ELB listening on ports 80 and 443
* Route53 hosted zone with a CNAME entry for the ELB