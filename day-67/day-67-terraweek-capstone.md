# Day 67 -- TerraWeek Capstone: Multi-Environment Infrastructure with Workspaces and Modules
## TASK-1
Before building the project, i understands workspaces:

```bash
mkdir terraweek-capstone && cd terraweek-capstone
terraform init

# See current workspace
terraform workspace show                    # default

# Create new workspaces
terraform workspace new dev
terraform workspace new staging
terraform workspace new prod

# List all workspaces
terraform workspace list

# Switch between them
terraform workspace select dev
terraform workspace select staging
terraform workspace select prod
```

Answer:
1. What does `terraform.workspace` return inside a config?
* It returns the workspace currently you are on which.

2. Where does each workspace store its state file?
* Workspace stores it's each file  Stored locally in a folder named terraform.tfstate.d/dev/terraform.tfstate.

3. How is this different from using separate directories per environment?
* Terraform Workspaces (Same Files): You use one directory with the exact same code files. Terraform automatically swaps out the isolated state storage path behind the scenes when you switch workspaces.

* Separate Directories (Different Files): You create separate physical folders on disk (like /dev, /staging, /prod). Each folder has its own configuration files and its own manually defined backend paths.

---

## TASK-2
I Create this layout/infrastructure:

```
terraweek-capstone/
  main.tf                   # Root module -- calls child modules
  variables.tf              # Root variables
  outputs.tf                # Root outputs
  providers.tf              # AWS provider and backend
  locals.tf                 # Local values using workspace
  dev.tfvars                # Dev environment values
  staging.tfvars            # Staging environment values
  prod.tfvars               # Prod environment values
  .gitignore                # Ignore state, .terraform, tfvars with secrets
  modules/
    vpc/
      main.tf
      variables.tf
      outputs.tf
    security-group/
      main.tf
      variables.tf
      outputs.tf
    ec2-instance/
      main.tf
      variables.tf
      outputs.tf
```

Create the **".gitignore"**:
```
.terraform/
*.tfstate
*.tfstate.backup
*.tfvars
.terraform.lock.hcl
```

#### Why is this file structure considered best practice?
* Managing everything in structure and easy to understand and easy to access each resource file, it make resolving errors easy and veasy to find required file, and when another developer try to read code it makes easier to understand him the code.

---

## TASK-3
Create three focused modules:

**Module 1: `modules/vpc/`**
- Input: `cidr`, `public_subnet_cidr`, `environment`, `project_name`
- Resources: VPC, public subnet, internet gateway, route table, route table association
- Output: `vpc_id`, `subnet_id`
- All resources tagged with environment and project name

**Module 2: `modules/security-group/`**
- Input: `vpc_id`, `ingress_ports`, `environment`, `project_name`
- Resources: Security group with dynamic ingress rules, allow all egress
- Output: `sg_id`

**Module 3: `modules/ec2-instance/`**
- Input: `ami_id`, `instance_type`, `subnet_id`, `security_group_ids`, `environment`, `project_name`
- Resources: EC2 instance with tags
- Output: `instance_id`, `public_ip`

Write and validate each module:
```bash
terraform validate
```

---

### TASK-4
**`locals.tf`:**
```hcl
locals {
  environment = terraform.workspace
  name_prefix = "${var.project_name}-${local.environment}"

  common_tags = {
    Project     = var.project_name
    Environment = local.environment
    ManagedBy   = "Terraform"
    Workspace   = terraform.workspace
  }
}
```

**`variables.tf`:**
```hcl
variable "project_name" {
  type    = string
  default = "terraweek"
}

variable "vpc_cidr" {
  type = string
}

variable "subnet_cidr" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "ingress_ports" {
  type    = list(number)
  default = [22, 80]
}
```

**`main.tf`** -- call all three modules, passing workspace-aware names and variables.

**Environment-specific tfvars:**

`dev.tfvars`:
```hcl
vpc_cidr      = "10.0.0.0/16"
subnet_cidr   = "10.0.1.0/24"
instance_type = "t2.micro"
ingress_ports = [22, 80]
```

`staging.tfvars`:
```hcl
vpc_cidr      = "10.1.0.0/16"
subnet_cidr   = "10.1.1.0/24"
instance_type = "t2.small"
ingress_ports = [22, 80, 443]
```

`prod.tfvars`:
```hcl
vpc_cidr      = "10.2.0.0/16"
subnet_cidr   = "10.2.1.0/24"
instance_type = "t3.small"
ingress_ports = [80, 443]
```

**`providers.tf`:**
```hcl
terraform {
  required_version = ">= 1.5.0" # Prevents execution on outdated CLI engines

  required_providers {
    aws = {
      source  = "hashicorp/aws" # Tells Terraform to fetch the official plugin
      version = "~> 5.0"        # Pins version to v5.x to prevent breaking upgrades
    }
  }
}

provider "aws" {
  region = "us-west-1"
}
```

* Notice: dev allows SSH, prod does not. Different CIDRs prevent overlap. Instance types scale up per environment.

---

### Task 5: Deploy All Three Environments
Deploy each environment using its workspace and tfvars file:

**Dev:**
```bash
terraform workspace select dev
terraform plan -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"
```

**Staging:**
```bash
terraform workspace select staging
terraform plan -var-file="staging.tfvars"
terraform apply -var-file="staging.tfvars"
```

**Prod:**
```bash
terraform workspace select prod
terraform plan -var-file="prod.tfvars"
terraform apply -var-file="prod.tfvars"
```

After all three are deployed, verify:
```bash
# Check each workspace's resources
terraform workspace select dev && terraform output
terraform workspace select staging && terraform output
terraform workspace select prod && terraform output
```

![alt text](<Screenshot From 2026-10-27 21-58-28.png>)

Go to the AWS console and verify:
- Three separate VPCs with different CIDR ranges
- Three EC2 instances with different instance types
- Different Name tags per environment: `terraweek-dev-server`, `terraweek-staging-server`, `terraweek-prod-server`

![alt text](<Screenshot From 2026-10-27 21-44-27.png>)
![alt text](<Screenshot From 2026-10-27 22-00-00.png>)
![alt text](<Screenshot From 2026-10-27 22-00-14.png>)
![alt text](<Screenshot From 2026-10-27 22-00-26.png>)

#### Verify: Are all three environments completely isolated from each other?
* **YES!** All three environments are completely isolated from each other.

---

## TASK-6

1. **File structure** -- separate files for providers, variables, outputs, main, locals
* Easy to understand, neet and clean, easy to access each resource file, it make resolving errors easy and veasy to find required file, and when another developer try to read code it makes easier to understand him the code.

2. **State management** -- always use remote backend, enable locking, enable versioning
* Always use a **Remote Backend (S3)**: Stores your state file securely in a central cloud bucket instead of on your local machine, keeping data safe and enabling team collaboration.
* Enable **State Locking (DynamoDB)**: Prevents concurrent executions. If two engineers run an operation at the same time, the backend blocks one, saving your infrastructure from corruption.
* Enable **Versioning (S3 Feature)**: Keeps a full rolling history of your state modifications. If an operation accidentally corrupts the current state, you can roll back instantly to a working version.

3. **Variables** -- never hardcode, use tfvars per environment, validate with `validation` blocks
* Never Hardcode: Extract values into variables to keep your blueprints reusable.
* .tfvars Per Environment: Use separate values files (e.g., dev.tfvars, prod.tfvars) to switch data configurations instantly.
8 validation Blocks: Add strict rules inside code to block bad inputs before they deploy.

* Example:

```hcl
variable "environment" {
  type = string
  default = "dev"
}
```

4. **Modules** -- one concern per module, always define inputs/outputs, pin registry module versions
* One Concern: Keep each module single-purpose (e.g., only VPC or only S3) for easy reuse and maintenance.
* Inputs/Outputs: Explicitly define parameters to pass data in and expose results for other resources to use.
* Pin Versions: Always lock registry modules to an exact version (e.g., version = "5.13.0") to stop unexpected updates from breaking your code.

5. **Workspaces** -- use for environment isolation, reference `terraform.workspace` in configs
* Environment Isolation: Use workspaces to manage separate states (like dev and prod) using the exact same configuration files.
* Reference terraform.workspace: Use this built-in string variable to dynamically alter resource names and sizes based on your active workspace context.

* Example:

```hcl
# Automatically alters the resource name prefix based on the active workspace
resource "aws_vpc" "main" {
name = "${var.environment}-vpc"
```

6. **Security** -- .gitignore for state and tfvars, encrypt state at rest, restrict backend access
* .gitignore State & .tfvars: Never commit state files (which hold plain-text secrets) or your variable definition files to git repositories.
* Encrypt State at Rest: Enable explicit encryption on your remote S3 state bucket to ensure cloud data is unreadable to unauthorized parties.
* Restrict Backend Access: Use strict IAM policies and roles to ensure only specific CI/CD pipelines or senior engineers can read or modify the storage backend.

7. **Commands** -- always run `plan` before `apply`, use `fmt` and `validate` before committing
* Always plan before apply: Never run an apply blindly. Check the generated plan output first to verify exactly what resources are being added, changed, or destroyed.
* Use fmt: Run terraform fmt to automatically standardize code spacing, layouts, and indentation according to official style guidelines.
* Use validate: Run terraform validate to check configuration syntax and variable matching for internal correctness before tracking or committing.

8. **Tagging** -- tag every resource with project, environment, and managed-by
* Tag Every Resource: Attach constant metadata to all cloud resources to track costs, owners, and environments instantly.

* Example:
```hcl
tags = {
  Project     = var.project_name
  Environment = terraform.workspace
  ManagedBy   = "Terraform"
}
```
9. **Naming** -- consistent prefix pattern: `<project>-<environment>-<resource>`
* Consistent Prefix: Always use the strict pattern <project>-<environment>-<resource> for all resource names.
* Why It Matters: This eliminates naming confusion, stops resource cross-contamination, and makes cloud filtering clean and intuitive.

* Example:
```hcl
resource "aws_security_group" "main" {
  name   = "${var.project_name}-${terraform.workspace}-sg"
  vpc_id = var.vpc_id

  tags = {
    Project     = var.project_name
    Environment = terraform.workspace
    ManagedBy   = "Terraform"
  }
}
```

10. **Cleanup** -- always `terraform destroy` non-production environments when not in use
* Always terraform destroy: Wipe out non-production environments (dev, staging) as soon as testing wraps up or work hours end.
* Why It Matters: This stops cloud bill creep and prevents idle, unmonitored infrastructure from becoming easy targets for security breaches.


---

## TASK-7
Clean up all three environments in reverse order:

```bash
terraform workspace select prod
terraform destroy -var-file="prod.tfvars"

terraform workspace select staging
terraform destroy -var-file="staging.tfvars"

terraform workspace select dev
terraform destroy -var-file="dev.tfvars"
```

#### Verify in the AWS console -- all VPCs, instances, security groups, and gateways should be gone.
* **YES!** my AWS console is fully clean, all VPCs, instances, security groups, and gateways should is gone.

Delete the workspaces:
```bash
terraform workspace select default
terraform workspace delete dev
terraform workspace delete staging
terraform workspace delete prod
```

**Verify:** Is your AWS account completely clean?
* **YES!** my AWS Account is completely clean.

---