variable "aws_region" {
  default = "ap-south-1"
}

variable "ami_id" {
  default = "ami-00bb6a80f01f03502" # Replace with Ubuntu AMI ID for ap-south-1
}

variable "instance_type" {
  default = "t2.medium"
}

variable "key_name" {
  default = "DevOps"
}

variable "root_volume_size" {
  default = 15
  description = "Size of the root volume in GiB"
}

variable "root_volume_type" {
  default = "gp3"
  description = "Type of the root volume (e.g., gp2, gp3, io1)"
}

variable "security_group_name" {
  default = "devops-sg"
}

variable "inbound_ports" {
  default = [
    22,  # SSH
    25,  # SMTP
    80,  # HTTP
    443, # HTTPS
    2000, # Custom Port
    11000, # Custom Port
    6443, # Kubernetes API Server
    465,  # SMTP (SSL) - Email over SSL
    "2000-11000" # Range of Ports
  ]
}

variable "instance_names" {
  default = {
    Server      = "Install AWS CLI, Terraform, Kubectl"
    SonarQube   = "SonarQube"
    Nexus       = "Nexus"
    Jenkins     = "Java 17, Jenkins, Docker, Trivy, Kubectl"
  }
}
