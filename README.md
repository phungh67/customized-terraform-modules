# 🏗️ Customized Terraform Modules

![GitHub language count](https://img.shields.io/github/languages/count/phungh67/customized-terraform-modules?style=flat-square)
![Top Language](https://img.shields.io/github/languages/top/phungh67/customized-terraform-modules?style=flat-square&logo=terraform)
![Status](https://img.shields.io/badge/Status-Experimental%20%2F%20Testing-red?style=flat-square)
![AI-Free Code](https://img.shields.io/badge/Code-100%25%20AI--Free-black?style=flat-square)
![AI-Assisted Docs](https://img.shields.io/badge/Docs-AI--Assisted-blue?style=flat-square)

This is my personal library, contains Terraform modules that I use frequently (networking, computing and S3 bucket). In the future, there will be more modules, like Kubernetes clusters, computing clusters, or simply some ECS clusters for those like containerized deployment but too lazy for installing and manage a mess of `Docker` container (but maybe `Podman`or `containerd` instead, know knows?) 

> ⚠️ **Warning**
> These modules are currently in development, hence it does not "error-proof".
> * They still contain known (and unknown) bugs.
> * They have **not** been fully verified or peer-reviewed.
> * They have **NOT** been audited or tested against potential security vulnerabilities. 
> * **Do not use these modules in a production environment.**

## 📦 Available Modules

Currently implemented modules (in testing):

* **[`/vpc`](./vpc/)** - Custom Virtual Private Cloud (VPC) module handling subnets, route tables, and internet/NAT gateways. Comes with several common topologies: single subnet for quick testing, 2 layers for public-private architecture and 3 layers for those requires strictly separation between application subnets and data subnet.
* **[`/ec2-lb`](./ec2-lb/)** - Combined EC2 and Load Balancer definitions for quick application server spin-ups. Also allows user to choose Bastion Host deployment or just simlpy direct remote in the machine (not recommend to do so).
* **[`/s3-storage`](./s3-storage/)** - General-purpose S3 bucket module featuring environment-based tagging, dynamic region namespaces, and optional dynamic CORS configurations. This bucket is meant to be used in static website development, or to store all the static assests of your service.

## 🚀 Upcoming Modules (Roadmap)

This repository is actively being expanded. The following modules are currently in the pipeline:

- [ ] **ECS (Elastic Container Service):** Fargate and EC2-backed cluster definitions, task definitions, and service autoscaling.
- [ ] **ALB (Application Load Balancer):** A dedicated, standalone ALB module with dynamic listener rules, target groups, and ACM certificate integration.
- [ x ] **Static Web with S3:** A fully automated module for provisioning S3 buckets configured for static website hosting, complete with CloudFront distribution and strict Bucket Policies.
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

## 🚥 CI/CD & Automated Testing

This repository uses GitHub Actions for continuous integration to ensure code quality and security across all modules. The pipeline includes formatting checks (`terraform fmt`), syntax validation, and static security analysis (e.g., tfsec).

Note on Pipeline Failures:
A "failed" workflow run does not inherently mean the infrastructure code is broken or contains an error. Security scanners enforce strict, enterprise-grade policies. A failure might simply indicate a flagged security rule that is acceptable for experimental, sandbox, or local development environments, but would otherwise be blocked in a production environment.

In the future, an updated `GitHub Actions` pipeline will be implemented, depends on user's intention, it will change the way "validate and formatted" check works, hence, allowing the "PASSED" result.

## 👨‍💻 Author

**Huy Hoang Phung**
* *Cloud & DevOps Engineer*
* *M.Sc. Candidate in Computer Systems and Cybersecurity @ Chalmers*
* [GitHub Profile](https://github.com/phungh67)
