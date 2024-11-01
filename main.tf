provider "aws" {
  region = "us-east-1"  # Set to us-east-1
}

resource "aws_security_group" "apache_sg" {
  name        = "apache_sg"
  description = "Allow HTTP traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["99.166.72.74/32"]  # Your IP address
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic
  }
}

resource "aws_instance" "web" {
  ami           = "ami-06b21ccaeff8cd686"  # Replace with a valid AMI ID for us-east-1
  instance_type = "t2.small"  # Change instance type if necessary
  security_groups = [aws_security_group.apache_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              set -x  # Enable debugging
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd

              # Create a simple HTML page
              cat <<EOL > /var/www/html/index.html
              <!DOCTYPE html>
              <html lang="en">
              <head>
                  <meta charset="UTF-8">
                  <meta name="viewport" content="width=device-width, initial-scale=1.0">
                  <title>Welcome to My Demo Website</title>
                  <style>
                      body {
                          font-family: Arial, sans-serif;
                          background-color: #f4f4f4;
                          margin: 0;
                          padding: 0;
                      }
                      header {
                          background: #35424a;
                          color: #ffffff;
                          padding: 20px 0;
                          text-align: center;
                      }
                      section {
                          margin: 20px;
                          padding: 20px;
                          background: #ffffff;
                          border-radius: 5px;
                          box-shadow: 0 0 10px rgba(0,0,0,0.1);
                      }
                      footer {
                          text-align: center;
                          padding: 10px 0;
                          background: #35424a;
                          color: #ffffff;
                          position: absolute;
                          bottom: 0;
                          width: 100%;
                      }
                  </style>
              </head>
              <body>
                  <header>
                      <h1>Welcome to My Demo Website</h1>
                  </header>
                  <section>
                      <h2>Hello!</h2>
                      <p>This is a simple demo website hosted on an AWS EC2 instance using Terraform.</p>
                      <p>Feel free to explore and learn more about how to deploy applications in the cloud!</p>
                  </section>
                  <footer>
                      <p>&copy; 2024 My Demo Website</p>
                  </footer>
              </body>
              </html>
              EOL

              # Log status
              systemctl status httpd > /var/log/httpd_status.log 2>&1
              EOF
}

output "instance_id" {
  value = aws_instance.web.id
}

output "public_ip" {
  value = aws_instance.web.public_ip
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "ojo29298888383"  # The bucket name must be globally unique
  acl    = "private"  # Set the access control list

  tags = {
    Name        = "MyBucket"
    Environment = "Dev"
  }
}

output "bucket_id" {
  value = aws_s3_bucket.my_bucket.id
}

output "bucket_arn" {
  value = aws_s3_bucket.my_bucket.arn
}
