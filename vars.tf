variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}

variable "AWS_REGION" {
    default = "us-east-1"
}

variable "environment" {
    type        = string
    description = "Test Environment"
    default     = "silkov-test"
}

variable "vpc_cidr" {
    type        = string
    description = "CIDR block of the vpc"
    default     = "10.0.0.0/16"
}

variable "public_profile" {
    type    = map
    default = {
        subnet_1    = {
            cidr    = "10.0.113.0/24"
            az      = "us-east-1a"
        }
        subnet_2    = {
            cidr    = "10.0.114.0/24"
            az      = "us-east-1b"
        }
    }
  
}

# variable "private_profile" {
#     type      = map
#     default   = {
#         subnet_1 = {
#             cidr  = "10.0.13.0/24"
#             az    = "us-east-1a"
#         }
#         subnet_2 = {
#             cidr  = "10.0.14.0/24"
#             az    = "us-east-1b"
#         }
#     }
# }

variable "private_subnets_cidr" {
    type        = string
    description = "CIDR block for Private Subnet"
    default     = "10.0.13.0/24"
}

variable "availability_zones" {
    type        = list(string)
    description = "AZ in which all the resources will be deployed"
    default     = ["us-east-1a", "us-east-1b"]
}

variable "domain_name" {
    type    = string
    default = "isilkov-test-project.com"
}

variable "project_tags" {
    type        = map(string)
    description = "Tags used for aws"
    default     = {
        Project     = "aws-terraform-test"
        Owner       = "Ilya Silkov"
        Terraform   = "true"
    }
}