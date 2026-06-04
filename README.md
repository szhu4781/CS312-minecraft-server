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
| Tool | Version |
|------|---------|
| Terraform | 1.0 or greater |
| Ansible | 2.9 or greater |
| AWS CLI | 2.0 or greater |
| nmap | any |

### Credentials
- An AWS Academy account with an active Learner Lab session (start the lab if you haven't already)
- AWS credentials configured at `~/.aws/credentials`:
```
[default]
aws_access_key_id=YOUR_ACCESS_KEY
aws_secret_access_key=YOUR_SECRET_KEY
aws_session_token=YOUR_SESSION_TOKEN
```
- An existing AWS key pair (`.pem` file) for SSH access

## Environment
This project was developed and run from Ubuntu (WSL on Windows 10). Since Ansible doesn't natively support Windows, WSL or a Linux/macOS machine is recommended.

## Pipeline
+------------------+       +-------------------+       +----------------------+
|   Terraform      |  -->  |   Ansible         |  -->  |   Minecraft Server   |
|                  |       |                   |       |                      |
| - Security group |       | - Install Java 25 |       | - Running on port    |
| - EC2 instance   |       | - Download jar    |       |   25565              |
|                  |       | - Accept EULA     |       | - Auto-starts on     |
|                  |       | - Setup systemd   |       |   reboot             |
+------------------+       +-------------------+       +----------------------+

