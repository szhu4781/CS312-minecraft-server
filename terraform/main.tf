terraform {
	required_providers {
		aws = {
			source	= "hashicorp/aws"
			version = "~> 5.0"
		}
	}
}

provider "aws" {
	region = "us-east-1"
}

resource "aws_security_group" "minecraft" {
	name		= "minecraft-sg-tf"
	description	= "Allow SSH and Minecraft"

	ingress {
		from_port	= 22
		to_port		= 22
		protocol	= "tcp"
		cidr_blocks	= ["0.0.0.0/0"]
	}	

	ingress {
		from_port	= 25565
		to_port		= 25565
		protocol	= "tcp"
		cidr_blocks	= ["0.0.0.0/0"]
	}

	egress {
		from_port	= 0
		to_port		= 0
		protocol	= "-1"
		cidr_blocks	= ["0.0.0.0/0"]
	}
}

resource "aws_instance" "minecraft" {
	ami			= "ami-0953e2223326856ce"
	instance_type		= "t4g.small"
	key_name		= var.key_name
	vpc_security_group_ids	= [aws_security_group.minecraft.id]

	tags = {
		Name = "minecraft-server"
	}
}
