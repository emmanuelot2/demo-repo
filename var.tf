variable "instance_type" {
  description = "Type of EC2 instance"
  default     = "t2.micro"
}

variable "ami" {
  description = "AMI ID for the EC2 instance"
  default     = "ami-06b21ccaeff8cd686"  # Change to a valid AMI ID for us-east-1
}
