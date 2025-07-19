variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
  
}

variable "public_subnet" {
    description = "CIDR block for the public subnet"
    type        = map(object({
        cidr_block        = string
        availability_zone = string
    }))
    default = {
      "public_subnet1" = {
        cidr_block        = "10.0.1.0/24"
        availability_zone = "us-east-1a"
      }
        "public_subnet2" = {
            cidr_block        = "10.0.2.0/24"
            availability_zone = "us-east-1b"
        }
    }  
}

variable "app_servers" {
    type = map(object({
        subnet_key      = string
    }))
    default = {
      "app-server1" = {
        subnet_key = "public_subnet1"
      }
      "app-server2" = {
        subnet_key = "public_subnet2"
      }
      "master-server" = {
        subnet_key = "public_subnet1"
      }
      "worker-server1" = {
        subnet_key = "public_subnet2"
      }
      "worker-server2" = {
        subnet_key = "public_subnet1"
      }
    }
  
}

variable "instance_type" {
  description = "Type of EC2 instance to use"
  type        = string
  default     = "t2.micro"
  
}

variable "ami_id" {
  description = "AMI ID to use for the EC2 instances"
  type        = string
  default     = "ami-05ffe3c48a9991133"
  
}