variable "aws_access_key" {}  # 空の変数を定義
variable "aws_secret_key" {}

variable "aws_region" {
    default = "ap-northeast-1"  # デフォルト値を設定
}

variable "aws_db_username" {}
variable "aws_db_password" {}

variable "aws_db_wp" {}
variable "aws_db_wp_username" {}

variable "aws_key_name" {}
variable "ssh_key_file" {}

variable "bucket_name" {}
variable "index" {}

variable "acm_certificate_arn" {}

variable "aws_vpc_name" {}
variable "aws_subnet_public_name" {}
variable "aws_subnet_private_db1" {}
variable "aws_subnet_private_db2" {}
variable "aws_internet_gateway_name" {}
variable "aws_route_table_name" {}
variable "aws_security_group_web_name" {}
variable "aws_security_group_db_name" {}
variable "aws_db_subnet_group_name" {}
variable "aws_db_instance_identifer" {}
variable "aws_instance_name" {}
