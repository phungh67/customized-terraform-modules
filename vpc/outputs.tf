output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  description = "The output list, contains all IDs of the public subnets"
  value       = aws_subnet.public_subnets[*].id
}

output "private_subnet_ids" {
  description = "The list contains all IDs of the private subnets"
  value       = aws_subnet.private_subnets[*].id
}

output "isolated_subnet_ids" {
  description = "The list contains all IDs of the isolated subnets if any"
  value       = aws_subnet.isolated_private_subnets[*].id
}