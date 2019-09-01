locals {
  bucket_name = "${var.environment_tag}-${var.s3_web_bucket}"
}
# INSTANCES #
resource "aws_instance" "instances" {
  count         = var.instance_count
  ami           = "ami-02f706d959cedf892"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnets[count.index % var.subnet_count].id
  vpc_security_group_ids = [
  aws_security_group.nginx-sg.id]
  key_name = var.key_name

  // Connection for the remote-exec provisioner, ssh
  connection {
    user        = "ec2-user"
    private_key = file(var.private_key_path)
    host        = self.public_ip
  }

  provisioner "file" {
    content     = <<-EOF
      access_key = ${aws_iam_access_key.write_user.id}
      secret_key = ${aws_iam_access_key.write_user.secret}
      use_https = True
      bucket_location = US
    EOF
    destination = "/home/ec2-user/.s3cfg"
  }

  provisioner "file" {
    content     = <<-EOF
      /var/log/nginx/*log {
          daily
          rotate 10
          missingok
          compress
          sharedscripts
          postrotate
            INSTANCE_ID=`curl --silent http://169.254.169.254/latest/meta-data/instance-id`
            /usr/local/bin/s3cmd sync /var/log/nginx/access.log-* s3://${aws_s3_bucket.web_bucket.id}/$INSTANCE_ID/nginx/
            /usr/local/bin/s3cmd sync /var/log/nginx/error.log-* s3://${aws_s3_bucket.web_bucket.id}/$INSTANCE_ID/nginx/
          endscript
    }
    EOF
    destination = "/home/ec2-user/nginx"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install nginx -y",
      "sudo service nginx start",
      "sudo cp /home/ec2-user/.s3cfg /root/.s3cfg",
      "sudo cp /home/ec2-user/nginx /etc/logrotate.d/nginx",
      "sudo pip install s3cmd",
      "s3cmd get s3://${aws_s3_bucket.web_bucket.id}/website/index.html .",
      "s3cmd get s3://${aws_s3_bucket.web_bucket.id}/website/Globo_logo_Vert.png .",
      "sudo cp /home/ec2-user/index.html /usr/share/nginx/html/index.html",
      "sudo cp /home/ec2-user/Globo_logo_Vert.png /usr/share/nginx/html/Globo_logo_Vert.png",
      "sudo logrotate -f /etc/logrotate.conf"
    ]
  }
}


