# VPC
resource "aws_vpc" "tf_vpc" {
    cidr_block           = "10.0.0.0/16"
    instance_tenancy     = "default"
    enable_dns_support   = true
    enable_dns_hostnames = true
    tags {
        Name = "${var.aws_vpc_name}"
    }
}

# EC2 publicサブネット
resource "aws_subnet" "public_web" {
    vpc_id                  = "${aws_vpc.tf_vpc.id}"
    cidr_block              = "10.0.0.0/24"
    availability_zone       = "ap-northeast-1a"
    map_public_ip_on_launch = true
    tags {
        Name = "${var.aws_subnet_public_name}"
    }
}

# RDS privateサブネット1
resource "aws_subnet" "private_db1" {
    vpc_id            = "${aws_vpc.tf_vpc.id}"
    cidr_block        = "10.0.1.0/24"
    availability_zone = "ap-northeast-1a"
    tags {
        Name = "${var.aws_subnet_private_db1}"
    }
}

# RDS privateサブネット2
resource "aws_subnet" "private_db2" {
    vpc_id            = "${aws_vpc.tf_vpc.id}"
    cidr_block        = "10.0.2.0/24"
    availability_zone = "ap-northeast-1c"
    tags {
        Name = "${var.aws_subnet_private_db2}"
    }
}

# DB Subnet Group
resource "aws_db_subnet_group" "main" {
    name        = "tf_dbsubnet"
    description = "It is a DB subnet group on tf_vpc."
    subnet_ids  = ["${aws_subnet.private_db1.id}", "${aws_subnet.private_db2.id}"]
    tags {
        Name = "${var.aws_db_subnet_group_name}"
    }
}

# Internet Gateway
resource "aws_internet_gateway" "gw" {
    vpc_id = "${aws_vpc.tf_vpc.id}"
    tags {
        Name = "${var.aws_internet_gateway_name}"
    }
}

# Route Table
resource "aws_route_table" "public_rtb" {
    vpc_id = "${aws_vpc.tf_vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.gw.id}"
    }
    tags {
        Name = "${var.aws_route_table_name}"
    }
}

# Route Table サブネットとの紐付け
resource "aws_route_table_association" "public_a" {
    subnet_id      = "${aws_subnet.public_web.id}"
    route_table_id = "${aws_route_table.public_rtb.id}"
}
