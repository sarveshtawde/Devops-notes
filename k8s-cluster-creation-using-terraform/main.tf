provider "aws" {
  region = "ap-south-1" 
}

# --- 1. Security Group (The Firewall) ---
resource "aws_security_group" "k8s_sg" {
  name = "k8s_security_group"

  # Port 6443: Kubernetes API Server (Needed for Master)
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Port 22: SSH (So you can login)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Internal Traffic: Allow nodes to talk to each other freely
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# --- 2. Master Instance ---
resource "aws_instance" "master" {
  ami           = "ami-0dee22c13ea7a9a67" # Ubuntu 22.04 LTS
  instance_type = "t2.medium"           # Master needs at least 2 vCPUs
  vpc_security_group_ids = [aws_security_group.k8s_sg.id]
  key_name      = "aws_key"       # Change this to your key!

  # This line tells Terraform to run your script on boot
  user_data = file("install_k8s.sh")

  tags = { Name = "Master-Node" }
}

# --- 3. Worker Instance ---
resource "aws_instance" "worker" {
  ami           = "ami-0dee22c13ea7a9a67"
  instance_type = "t2.micro"            # Worker can be smaller
  vpc_security_group_ids = [aws_security_group.k8s_sg.id]
  key_name      = "aws_key"

  user_data = file("install_k8s.sh")

  tags = { Name = "Worker-Node" }
}