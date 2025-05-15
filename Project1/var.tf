variable "location"{
description = "The AWS region to deploy the infrastructure"
default = "us-east-1"
type = string
}

variable "cidr_block"{
    description = "The CIDR block for the VPC"
    type = string
    validation {
  condition = substr(var.cidr_block, 0, 3) == "172"
  error_message = "The CIDR block must start with 172."
}
}
  


variable "subnet_cidr_block"{
    description = "The CIDR block for the subnet"
    type = string
  
}


