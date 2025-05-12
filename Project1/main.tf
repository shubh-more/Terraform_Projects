terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.96.0"
    }
  }
}

provider "aws" {
 profile= "default" 
  region = "us-east-1"
}


# Create a VPC
resource "aws_vpc" "InfravPC" {
 cidr_block = "10.0.0.0/16" 
tags = {
    Name = "InfravPC"
  }

}

# Create a subnet in the VPC
resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.InfravPC.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "Infrasubnet "
  }
}

#internet gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.InfravPC.id

  tags = {
    Name = "internet_gateway"
  }
}

#route table
resource "aws_route_table" "Infrar-rt" {
  vpc_id = aws_vpc.InfravPC.id
  tags = {
    Name = "Infrar-rt"
  }
}

# Route to the internet
resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.Infrar-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}


#route table association
resource "aws_route_table_association" "Infra-rt_association" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.Infrar-rt.id
}

# Create a security group
resource "aws_security_group" "infra-sg" {
  vpc_id = aws_vpc.InfravPC.id
  name = "Primary-SG"
  description = "Primary-SG"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } 

   ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } 
   
  tags = {
    Name = "Primary-SG"

  }
}

# Create a security group for the EC2 instance
resource "aws_instance" "ec2_instance" {
 ami = "ami-084568db4383264d4" 
  instance_type = "t2.medium"
  key_name = "DevOpsKeyPair"
  security_groups = ["Primary-SG"]
  root_block_device{  
    volume_type = "gp2" 
    volume_size = 25
    delete_on_termination = true
    }
  tags = {
    Name = "Ubuntu Instance"
  }
}



