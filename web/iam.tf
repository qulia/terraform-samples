resource "aws_iam_user" "write_user" {
  name          = "${var.environment_tag}-s3-write-user"
  force_destroy = true
}

resource "aws_iam_access_key" "write_user" {
  user = aws_iam_user.write_user.name
}

resource "aws_iam_user_policy" "write_user_pol" {
  name   = "write"
  user   = aws_iam_user.write_user.name
  policy = <<-EOF
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": "s3:*",
                "Resource": [
                    "arn:aws:s3:::${local.bucket_name}",
                    "arn:aws:s3:::${local.bucket_name}/*"
                ]
            }
       ]
    }
    EOF

}