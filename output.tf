output "VPC" {
  value = aws_vpc.My_VPC.id
}

output "Public-Subnet-1" {
  value = aws_subnet.My_VPC_Subnet.id
}

output "Public-Subnet-3" {
  value = aws_subnet.My_VPC_Subnet3.id
}


output "Private-Subnet-2" {
  value = aws_subnet.My_VPC_Subnet2.id
}

output "Private-Subnet-4" {
  value = aws_subnet.My_VPC_Subnet4.id
}

