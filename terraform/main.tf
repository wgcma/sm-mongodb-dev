terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11"
    }
  }
  backend "s3" {
    bucket         = "sm-mdb-wing-resources-dev"
    key            = "state/statefile.tfstate"
    region         = "us-east-2"
    encrypt        = true
    dynamodb_table = "sm-mdb-wing-resource-dev-terraform-state-locks" # Optional but recommended
  }
}

# Configure after cluster is created
provider "kubernetes" {
  config_path = "~/.kube/config"
  # Or use kubeconfig from RKE2 setup
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "aws" {
  region = var.region
}

resource "aws_key_pair" "mdb-pub-key" {
  key_name   = "wing-new-key-1"
  public_key = file("/Users/wingma/.ssh/wing-new-key-1.pem.pub")
}

resource "aws_instance" "k3s" {
  ami                    = data.aws_ami.ubuntu-noble-24-amd64.id
  instance_type          = "m6a.large"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.k3s.id]
  key_name               = aws_key_pair.mdb-pub-key.key_name

  # Force recreation if key changes
  lifecycle {
    create_before_destroy = true
  }

  user_data = file("${path.module}/scripts/k3s-install.sh")
  root_block_device {
    volume_size           = 50
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = true
    tags = {
      Name = "k3s-server"
    }
  }
}
