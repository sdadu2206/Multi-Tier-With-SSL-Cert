resource "aws_instance" "ec2" {
  count         = length(var.instance_names)
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.devops_key.key_name   # Referencing the new key pair
  security_groups = [aws_security_group.devops_sg.name]
  tags = {
    Name = var.instance_names[count.index]
  }

  root_block_device {
    volume_size           = var.root_volume_size    # Size in GiB
    volume_type           = var.root_volume_type    # Type of volume (e.g., gp3)
    delete_on_termination = true                    # Automatically delete root volume on instance termination
  }

  user_data = <<-EOT
  #!/bin/bash
  case "${var.instance_names[count.index]}" in
    "Install AWS CLI, Terraform, Kubectl")
      sudo apt update -y
      sudo apt install -y awscli unzip
      curl -o terraform.zip https://releases.hashicorp.com/terraform/1.5.0/terraform_1.5.0_linux_amd64.zip
      unzip terraform.zip
      sudo mv terraform /usr/local/bin/
      curl -LO "https://dl.k8s.io/release/v1.27.0/bin/linux/amd64/kubectl"
      chmod +x kubectl
      sudo mv kubectl /usr/local/bin/
      ;;
    "SonarQube")
      sudo apt update -y
      sudo apt install -y openjdk-17-jdk wget
      wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.0.65499.zip
      sudo apt install -y unzip
      unzip sonarqube-9.9.0.65499.zip
      ;;
    "Nexus")
      sudo apt update -y
      sudo apt install -y openjdk-17-jdk wget
      wget https://download.sonatype.com/nexus/3/latest-unix.tar.gz
      tar -xvf latest-unix.tar.gz
      ;;
    "Java 17, Jenkins, Docker, Trivy, Kubectl")
      sudo apt update -y
      sudo apt install -y openjdk-17-jdk docker.io curl
      curl -fsSL https://get.docker.com | sh
      curl -fsSL https://trivy.io/install.sh | sh
      curl -LO "https://dl.k8s.io/release/v1.27.0/bin/linux/amd64/kubectl"
      chmod +x kubectl
      sudo mv kubectl /usr/local/bin/
      ;;
  esac
  EOT
}
