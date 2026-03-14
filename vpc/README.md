# ☁️ Custom VPC Terraform Module

![Status](https://img.shields.io/badge/Status-Experimental%20%2F%20Testing-red?style=flat-square)
![Terraform](https://img.shields.io/badge/Terraform-HCL-844FBA?style=flat-square&logo=terraform)

This module is designed to rapidly provision an AWS Virtual Private Cloud (VPC) with industry-standard subnet topologies. Whether you need a simple public-facing sandbox or a secure 3-tier architecture, this module dynamically adapts based on the variables you provide.

> ⚠️ **TESTING ONLY** > Like the rest of this repository, this module is for **experimental use** and is not audited for production environments. 
> *Code is 100% human-written; this README is AI-assisted.*

## 🏗️ Supported Topologies

This module intelligently builds your network layers based on the subnet CIDR blocks you pass into it:

1. **Public Only:** Good for quick, non-sensitive public-facing experiments.
2. **Public + Private (2-Tier):** Standard setup for load balancers (public) routing to application servers (private). Includes NAT Gateways for private outbound access.
3. **Public + Private + Database (3-Tier):** Secure architecture where database subnets are completely isolated from direct public routing.

## ⚙️ How to Use (Inputting Variables)

To use this module, reference it in your Terraform code and pass in your desired CIDR blocks. The module figures out the rest (creating Internet Gateways, NAT Gateways, and Route Tables) automatically.

### Example: Creating a 3-Tier Architecture

Create a `terraform.tfvars` file (or define these directly in your module call) to specify your layers:

```hcl
# terraform.tfvars

# 1. Define the base network
vpc_cidr     = "10.0.0.0/16"
vpc_name     = "my-custom-vpc"
environment  = "dev"

# 2. Define your Availability Zones
azs          = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]

# 3. Define the Subnet Layers (The magic happens here)
# Passing all three lists triggers the 3-Tier topology automatically
public_subnets   = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
private_subnets  = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
database_subnets = ["10.0.20.0/24", "10.0.21.0/24", "10.0.22.0/24"]

# Optional: Enable NAT Gateways for private subnet internet access
enable_nat_gateway = true
single_nat_gateway = true # Set to true to save costs in dev environments!
```

### Module Calling Example

In your `main.tf`, just call the module and pass those variables:

```hcl
module "vpc" {
  source = "github.com/phungh67/customized-terraform-modules//vpc"

  vpc_name           = var.vpc_name
  vpc_cidr           = var.vpc_cidr
  azs                = var.azs
  
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  database_subnets   = var.database_subnets
  
  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway
  
  tags = {
    Environment = var.environment
    Terraform   = "true"
  }
}
```

## 🛠️ Modifying the Topologies

* **Want a Public-Only VPC?** Simply leave the `private_subnets` and `database_subnets` lists empty (or don't pass them at all). The module will skip creating NAT Gateways and private route tables.
* **Want a 2-Tier VPC?** Pass `public_subnets` and `private_subnets`, but leave `database_subnets` out.

## 👨‍💻 Author

**Huy Hoang Phung**
* *Cloud & DevOps Engineer*
* *M.Sc. Candidate in Computer Systems and Cybersecurity @ Chalmers*
* [GitHub Profile](https://github.com/phungh67)
