# 🏗️ Customized Terraform Modules

![GitHub language count](https://img.shields.io/github/languages/count/phungh67/customized-terraform-modules?style=flat-square)
![Top Language](https://img.shields.io/github/languages/top/phungh67/customized-terraform-modules?style=flat-square&logo=terraform)
![Status](https://img.shields.io/badge/Status-Experimental%20%2F%20Testing-red?style=flat-square)
![AI-Free Code](https://img.shields.io/badge/Code-100%25%20AI--Free-black?style=flat-square)
![AI-Assisted Docs](https://img.shields.io/badge/Docs-AI--Assisted-blue?style=flat-square)

Welcome to my personal library of **Terraform Modules**. This repository serves as a sandbox and central registry for self-written, highly customizable Infrastructure as Code (IaC) modules. 

> ⚠️ **CRITICAL WARNING - USE AT YOUR OWN RISK**
> These modules are strictly for **testing and experimentation only**. 
> * They still contain known (and unknown) bugs.
> * They have **not** been fully verified or peer-reviewed.
> * They have **NOT** been audited or tested against potential security vulnerabilities. 
> * **Do not use these modules in a production environment.**

> 🧠 **100% AI-Free Code (But AI-Assisted Docs!)** > All Terraform configuration in this repository is proudly written by hand, without the use of generative AI coding assistants. However, this README was entirely AI-generated because I was way too lazy to write it myself!

## 📦 Available Modules

Currently implemented modules (in testing):

* **[`/vpc`](./vpc/)** - Custom Virtual Private Cloud (VPC) module handling subnets, route tables, and internet/NAT gateways.
* **[`/ec2-lb`](./ec2-lb/)** - Combined EC2 and Load Balancer definitions for quick application server spin-ups.

## 🚀 Upcoming Modules (Roadmap)

This repository is actively being expanded. The following modules are currently in the pipeline:

- [ ] **ECS (Elastic Container Service):** Fargate and EC2-backed cluster definitions, task definitions, and service autoscaling.
- [ ] **ALB (Application Load Balancer):** A dedicated, standalone ALB module with dynamic listener rules, target groups, and ACM certificate integration.
- [ ] **Static Web with S3:** A fully automated module for provisioning S3 buckets configured for static website hosting, complete with CloudFront distribution and strict Bucket Policies.
- [ ] **Standalone EC2:** Decoupled, highly parameterized EC2 instances with custom user-data bootstrapping and IAM instance profiles.

## ⚙️ How to Use (For Testing)

If you are brave enough to test these modules in a sandbox environment, you can source them directly into your main environment configurations using the GitHub URL:

```hcl
module "custom_vpc" {
  source = "[github.com/phungh67/customized-terraform-modules//vpc](https://github.com/phungh67/customized-terraform-modules//vpc)"
  
  # Module specific variables
  vpc_cidr             = "10.0.0.0/16"
  environment          = "dev"
}
```

## 👨‍💻 Author

**Huy Hoang Phung**
* *Cloud & DevOps Engineer*
* *M.Sc. Candidate in Computer Systems and Cybersecurity @ Chalmers*
* [GitHub Profile](https://github.com/phungh67)
