##################################################################################
# VARIABLES
##################################################################################

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "private_key_path" {}
variable "key_name" {
  default = "AwsTestDeployment"
}

variable "instance_count" {}
variable "subnet_count" {}

variable "network_address_space" {
  default = "10.1.0.0/16"
}

variable "s3_web_bucket" {}

variable "s3_web_bucket_content" {}

variable "environment_tag" {}

