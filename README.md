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
**Note:** If the AWS folder doesn't exist, make the directory with ```mkdir -p ~/.aws```, then run use ```nano```, ```vim```, or whatever built-in text editor to create the file to store your AWS credentials with the code above. Be sure to replace the placeholder values with your actual credentials!

## Environment
This project was developed and run from Ubuntu (WSL on Windows 10). Since Ansible doesn't natively support Windows, WSL or a Linux/macOS machine is recommended.

## Pipeline Diagram
```
+------------------+       +-------------------+       +----------------------+
|   Terraform      |  -->  |   Ansible         |  -->  |   Minecraft Server   |
|                  |       |                   |       |                      |
| - Security group |       | - Install Java 25 |       | - Running on port    |
| - EC2 instance   |       | - Download jar    |       |   25565              |
|                  |       | - Accept EULA     |       | - Auto-starts on     |
|                  |       | - Setup systemd   |       |   reboot             |
+------------------+       +-------------------+       +----------------------+
```


## Commands
### 1. Configure AWS credentials
Retrieve your credentials from the AWS Academy Learner Lab and paste them into
`~/.aws/credentials`. Also set your region in `~/.aws/config`:
```
[default]
region=us-east-1
```
**Note:** Click on **AWS Details** when the AWS Academy Learner Lab is active to see your credentials. You will also need to have a config file inside your AWS folder to set your region.

### 2. Provision AWS infrastructure with Terraform
Update the placeholder key pair name with your actual key pair name.
```bash
cd terraform
terraform init
terraform apply -var="key_name=<your-key-pair-name>"
```
Note the public IP output at the end, you will need it for the next step. 

### 3. Update the Ansible inventory
Open `ansible/inventory.ini` and replace the IP address with the one output by Terraform:
```ini
[minecraft]
<public_ip> ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/<your-key>.pem ansible_ssh_extra_args='-o StrictHostKeyChecking=no'
```
**Note:** Be sure to update the public IP address in the `ansible/inventory.ini` with the one you get from the output whenever you decide to destroy your old instance so that the Ansible playbook runs correctly.

### 4. Run the Ansible playbook
```
cd ..
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml
```

### 5. Tear down infrastructure (when done)
```
cd terraform
terraform destroy -var="key_name=<your-key-pair-name>"
```
This step is required whenever you start a new instance or log out of your Ubuntu terminal. Each time you start a new instance, the previous public IP address will be inactive, and you will need to generate a new IP address by applying with Terraform (go back to step 2).

## Connecting to the Server
Once the playbook completes, verify the server is reachable with nmap:
```
nmap -sV -Pn -p T:25565 <public_ip>
```
You should see output confirming Minecraft is running on port 25565. You can also connect directly using the Minecraft Java Edition client by adding `<public_ip>` as a multiplayer server address (`<public_ip>` would be the IP address you copied from the Terraform output).

## Resources
- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Ansible Documentation](https://docs.ansible.com/)
- [Minecraft Server Download](https://www.minecraft.net/en-us/download/server)
