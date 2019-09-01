
resource "aws_s3_bucket" "web_bucket" {
  bucket        = local.bucket_name
  acl           = "private"
  force_destroy = true

  policy = <<-EOF
    {
        "Version": "2008-10-17",
        "Statement": [
            {
                "Sid": "PublicReadForGetBucketObjects",
                "Effect": "Allow",
                "Principal": {
                    "AWS": "*"
                },
                "Action": "s3:GetObject",
                "Resource": "arn:aws:s3:::${local.bucket_name}/*"
            },
            {
                "Sid": "",
                "Effect": "Allow",
                "Principal": {
                    "AWS": "${aws_iam_user.write_user.arn}"
                },
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

resource "aws_s3_bucket_object" "website_files" {
  count  = length(var.s3_web_bucket_content)
  bucket = aws_s3_bucket.web_bucket.bucket
  key    = var.s3_web_bucket_content[count.index].key
  source = var.s3_web_bucket_content[count.index].source
  # use etag to update them when file content is changed
  etag = filemd5(var.s3_web_bucket_content[count.index].source)
}