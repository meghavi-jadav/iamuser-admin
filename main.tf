terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_group" "administration" {
  name = "administration"
}

resource "aws_iam_group_policy_attachment" "test-attach" {
  group      = aws_iam_group.administration.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_user" "admin-user" {
  name = "admin-1"

  tags = {
    Department = "Admin"
  }
}

resource "aws_iam_user_group_membership" "user-group-membership" {
  user = aws_iam_user.admin-user.name

  groups = [
    aws_iam_group.administration.name
  ]
}

resource "aws_iam_user_login_profile" "credentials" {
  user    = aws_iam_user.admin-user.name
}

resource "aws_iam_virtual_mfa_device" "example_mfa_device" {
    #  user_name = aws_iam_user.admin-user.name
     virtual_mfa_device_name = "mfa"
   }

output "qr_code_png" {
    value = aws_iam_virtual_mfa_device.example_mfa_device.qr_code_png
}

output "base_32_string_seed" {
    value = aws_iam_virtual_mfa_device.example_mfa_device.base_32_string_seed
}


# resource "aws_iam_group_policy" "admin_policy" {
#   name  = "admin_policy"
#   group = aws_iam_group.administration.name

#   # Terraform's "jsonencode" function converts a
#   # Terraform expression result to valid JSON syntax.
#   policy = jsonencode({
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Action": "*",
#             "Resource": "*"
#         }
#     ]
#   })
# }
