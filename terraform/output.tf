output "server_public_ip" {
  value = {
    for instance, details in aws_instance.servers :
    instance => details.public_ip
  }
  description = "Public IP addresses of the EC2 instances"
  
}

output "vpc_id" {
  value = aws_vpc.main-vpc.id
  description = "ID of the main VPC"
  
}

output "public_subnet_ids" {
  value = {
    for subnet, details in aws_subnet.public_subnet :
    subnet => details.id
  }
  description = "IDs of the public subnets"
  
}