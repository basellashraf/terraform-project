# 🌐 Terraform AWS Infrastructure Project

## 📌 Overview

This project provisions a full AWS infrastructure using **Terraform** with modular code and best practices.  
It includes:

- Custom VPC with subnets and route tables
- Bastion Host for secure SSH access to private instances
- EC2 Instances (public and private)
- Load Balancers (Application Load Balancer for public-facing traffic)
- Remote backend using **S3** for state and **DynamoDB** for locking

---

## 🧱 Project Structure

terraform_project/ ├── vpc/ │ ├── main.tf │ ├── output.tf │ └── variables.tf ├── ec2/ │ ├── main.tf │ ├── output.tf │ └── variables.tf ├── loadbalancer/ │ ├── main.tf │ ├── output.tf │ └── variables.tf ├── main.tf ├── provider.tf ├── variables.tf ├── output.tf ├── .gitignore

yaml
Copy
Edit

---

## 🔧 Prerequisites

- ✅ Terraform installed
- ✅ AWS CLI configured with credentials
- ✅ Valid AWS Key Pair (`.pem` file) for SSH access

---

## 🚀 Usage

Initialize the working directory:

```bash
terraform init
Review the execution plan:

bash
Copy
Edit
terraform plan
Apply the configuration:

bash
Copy
Edit
terraform apply
Destroy the infrastructure:

bash
Copy
Edit
terraform destroy
📤 Output
After terraform apply, the following IPs are written to a file using local-exec:

File: all-ips.txt

cpp
Copy
Edit
public-ip1   x.x.x.x
public-ip2   y.y.y.y
☁️ Remote Backend
State files are stored remotely to allow team collaboration and state locking:

S3 Bucket: terraform-state-bucket-basel-20250407

DynamoDB Table for Locking: terraform-locks

📁 Git Setup Notes
This repository includes a .gitignore file that excludes sensitive and unnecessary files:

markdown
Copy
Edit
.terraform/
terraform.tfstate
terraform.tfstate.backup
terraform.tfstate.d/
*.zip
*.pem
✍️ Author
Basel Ashraf
GitHub: https://github.com/basellashraf

✅ Status
Project is complete and ready for delivery.
All infrastructure components were tested successfully.

🖼️ Screenshots
You can add screenshots of the AWS Console or Terraform output here for demonstration
