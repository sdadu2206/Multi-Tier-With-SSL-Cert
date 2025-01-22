resource "tls_private_key" "devops_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "devops_key" {
  content  = tls_private_key.devops_key.private_key_pem
  filename = "${path.module}/DevOps.pem"
  provisioner "local-exec" {
    command = "chmod 400 ${path.module}/DevOps.pem"
  }
}

resource "aws_key_pair" "devops_key" {
  key_name   = var.key_name
  public_key = tls_private_key.devops_key.public_key_openssh
}
