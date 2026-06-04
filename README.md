# Minecraft Server Deployment on AWS EC2 - Automated Deployment
**Author:** Shengwei Zhu

**Date Created:** 06/04/2026

Last updated on 06/04/2026

## Description
This tutorial is made for automating the provisioning and configuration of a Minecraft Java Edition
server on AWS EC2 using Terraform and Ansible. 
**Terraform** handles the infrastructure provisioning:
- Creates an AWS security group with the necessary inbound rules
- Provisions an EC2 instance (t4g.small, Ubuntu 24.04 LTS ARM)
**Ansible** handles the server configuration:
- Installs Java 25
- Downloads the Minecraft server jar
- Accepts the EULA
- Configures and enables a systemd service for auto-start and proper shutdown

## Requirements
---
| Tool | Version |
|------|---------|
| Terraform | >= 1.0 |
| Ansible | >= 2.9 |
| AWS CLI | >= 2.0 |
| nmap | any |

### Credentials
- An active AWS Academy Learner Lab session
- AWS credentials configured at `~/.aws/credentials`:


