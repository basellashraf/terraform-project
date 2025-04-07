# 🌐 Terraform AWS Infrastructure Project

## 📌 Overview

This project provisions a full AWS infrastructure using **Terraform** with modular code and best practices.  
It includes:

- Custom VPC with subnets and route tables
- Bastion Host for secure SSH access to private instances
- EC2 Instances (public and private)
- Load Balancer (Application Load Balancer)
- Remote backend using **S3** for state and **DynamoDB** for locking

---

## 🧱 Project Structure

```
terraform_project/
├── vpc/
│   ├── main.tf
│   ├── output.tf
│   └── variables.tf
├── ec2/
│   ├── main.tf
│   ├── output.tf
│   └── variables.tf
├── loadbalancer/
│   ├── main.tf
│   ├── output.tf
│   └── variables.tf
├── main.tf
├── provider.tf
├── variables.tf
├── output.tf
├── .gitignore
```

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
```

Review the execution plan:

```bash
terraform plan
```

Apply the configuration:

```bash
terraform apply
```

Destroy the infrastructure:

```bash
terraform destroy
```

---

## 📤 Output

After applying, Terraform uses a `local-exec` to write instance public IPs into a file:

**File:** `all-ips.txt`

```
public-ip1   1.1.1.1
public-ip2   2.2.2.2
```

---

## ☁️ Remote Backend

The project uses remote state management with locking:

- **S3 Bucket:** `terraform-state-bucket-basel-20250407`
- **DynamoDB Table:** `terraform-locks`

---

## 📁 Git Setup Notes

The `.gitignore` file excludes Terraform-generated files and sensitive data:

```
.terraform/
terraform.tfstate
terraform.tfstate.backup
terraform.tfstate.d/
*.zip
*.pem
```

---

## ✍️ Author

**Basel Ashraf**  
GitHub: [https://github.com/basellashraf](https://github.com/basellashraf)

---



## ✅ Project Status

✔️ Infrastructure tested and provisioned successfully  
✔️ Ready for deployment or handoff
