variable "region" {
  description = "Enter the AWS Region to deploy the Infrastructure"
  type        = string
  default     = "us-east-1"
}

variable "az1" {
  description = "Enter the AWS Region to deploy the Infrastructure"
  type        = string
  default     = "us-east-1a"
}

variable "az2" {
  description = "Enter the AWS Region to deploy the Infrastructure"
  type        = string
  default     = "us-east-1b"
}

variable "public_key" {
  description = "Whether the KMS Key is Enabled or Disabled"
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDgiJZO6LcAt+KIQdnTbxyi4Y3N0wtgMxDXVSBMi5p7XKIJdX1A8Dql9UVN6srz4Hzz1u8j1RRvJKY1SUQ0qMja5y5QyPlCY8ChXigUuR4ecB35nA2sjo7FjkzzsRWWLWjO9VnKgX54JgP/kSyOWNp/egB70L/eyh0c60OG5QgJz3wBl131Q7gZ9DNhKftIeq8NKZWaY2AHm0U4erugKgJ9juFKTLRF4JANcmoOa2o1RcNKETW1TzB4m2HZJCcKDrINJK2UDHCyBGfrLn0skwV+3jMIQLAcoOYXPEKSEPMKTI8RV6N8id7AihL39wZl5UD2Hg5n7Jb+eyZtMBYfNmUX ec2-user@ip-172-31-18-193.ca-central-1.compute.internal"
}

variable "vpc_cidr" {
  description = "CIDR Block of VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet1_cidr" {
  description = "CIDR Block of Subnet1"
  type        = string
  default     = "10.0.0.0/24"
}

variable "subnet2_cidr" {
  description = "CIDR Block of Subnet2"
  type        = string
  default     = "10.0.1.0/24"
}

variable "server_port_web" {
  description = "The port the server will use for Mine_Map_Web_Server requests"
  default     = "80"
}

variable "server_port_app" {
  description = "The port the server will use for Mine_Map_App_Server requests"
  default     = "8080"
}

variable "corporate_cidr" {
  description = "The CIDR of the Corporate DataCenter to Access Instances"
  default     = "10.0.0.0/8"
}

variable "instance_type" {
  description = "EC2 Instances Type baed on your Server Requirement"
  type        = string
  default     = "t2.micro"
}

variable "bucket_name" {
  description = "S3 Bucket Name"
  type        = string
  default     = "minemapdata2023"
}

