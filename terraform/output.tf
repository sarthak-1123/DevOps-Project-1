output "server_public_ip" {
  value = aws_instance.servers[*].public_ip
  description = "Public IP addresses of the EC2 instances"
  
}

output "vpc_id" {
  value = aws_vpc.main-vpc.id
  description = "ID of the main VPC"
  
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnet[*].id
  description = "IDs of the public subnets"
  
}