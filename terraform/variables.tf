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

variable "sg_ingress_rule" {
  type = map(object({
    from_port   = number
    to_port     = number
    ip_protocol = string
    cidr_ipv4   = string
  }))
  default = {
    "http" = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
    },
    "ssh" = {
      from_port   = 22
      to_port     = 22
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
    }
    "api-server" = {
      from_port   = 6443
      to_port     = 6443
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
    }
    "etcd-server" = {
      from_port   = 2379
      to_port     = 2380
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
    }
    "kubelet" = {
      from_port   = 10250
      to_port     = 10252
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
    }
    "NodePort" = {
      from_port   = 30000
      to_port     = 32767
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
    }
  
  }
  description = "Security group ingress rules for the public security group"
}


variable "app_servers" {
    type = map(object({
        subnet_key      = string
    }))
    default = {
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
  default     = "t2.medium"
  
}

variable "ami_id" {
  description = "AMI ID to use for the EC2 instances"
  type        = string
  default     = "ami-0150ccaf51ab55a51"
  
}