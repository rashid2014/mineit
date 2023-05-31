data "aws_ami" "amzn-linux-2023-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}


resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = var.public_key
}

resource "aws_vpc" "customvpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "CustomVPC"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.customvpc.id

  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "publicrt" {
  vpc_id = aws_vpc.customvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "PublicRT"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id                  = aws_vpc.customvpc.id
  cidr_block              = var.subnet1_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.az1

  tags = {
    Name = "PublicSubnet1"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id                  = aws_vpc.customvpc.id
  cidr_block              = var.subnet2_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.az2

  tags = {
    Name = "PublicSubnet2"
  }
}


resource "aws_route_table_association" "publicsubnetassociation1" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.publicrt.id
}

resource "aws_route_table_association" "publicsubnetassociation2" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.publicrt.id
}

resource "aws_security_group" "websg" {
  name   = "mine-map-websg"
  vpc_id = aws_vpc.customvpc.id

  ingress {
    from_port   = var.server_port_web
    to_port     = var.server_port_web
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "ssh_rule1" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.corporate_cidr]
  security_group_id = aws_security_group.websg.id
}

resource "aws_security_group" "appsg" {
  name   = "mine-map-appsg"
  vpc_id = aws_vpc.customvpc.id

  ingress {
    from_port   = var.server_port_app
    to_port     = var.server_port_app
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "ssh_rule2" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.corporate_cidr]
  security_group_id = aws_security_group.appsg.id
}


resource "aws_instance" "mine_map_web" {
  ami                    = data.aws_ami.amzn-linux-2023-ami.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.deployer.key_name
  subnet_id              = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.websg.id]

  tags = {
    Name = "Mine_Map_Web_Server"
  }
}

resource "aws_instance" "mine_map_app" {
  ami                    = data.aws_ami.amzn-linux-2023-ami.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.deployer.key_name
  subnet_id              = aws_subnet.subnet2.id
  vpc_security_group_ids = [aws_security_group.appsg.id]

  tags = {
    Name = "Mine_Map_App_Server"
  }
}

resource "aws_s3_bucket" "databucket" {
  bucket = var.bucket_name


  tags = {
    Name        = "Mine Map Data Bucket"
    Environment = "dev"
  }
}

resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.databucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "versioning_data" {
  bucket = aws_s3_bucket.databucket.id
  versioning_configuration {
    status = "Enabled"
  }
}