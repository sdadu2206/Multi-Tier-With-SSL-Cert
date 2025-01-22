output "ec2_instance_ips" {
  value = {
    Server = aws_instance.Server.public_ip
    SonarQube = aws_instance.SonarQube.public_ip
    Nexus     = aws_instance.Nexus.public_ip
    Jenkins   = aws_instance.Jenkins.public_ip
  }
  description = "Public IPs of the EC2 instances"
}

output "key_pair_path" {
  value = "${path.module}/DevOps.pem"
  description = "Path to the DevOps PEM key file"
}
