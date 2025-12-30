terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
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

resource "aws_instance" "sm-mdb-server-wing-dev" {
  ami                    = data.aws_ami.ubuntu-noble-24-amd64.id
  instance_type          = "m6a.large"
  vpc_security_group_ids = ["sg-0316fed9d6e55d3dc"]

  root_block_device {
    volume_size           = 50
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = true
    tags = {
      Name = "sm-mdb-wing-dev"
    }
  }
}
