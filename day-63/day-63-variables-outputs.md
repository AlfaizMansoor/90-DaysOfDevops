# Day 63 -- Variables, Outputs, Data Sources and Expressions
## TASk-1
1. I create a **"variables.tf"** file with input variables for:
   - `region` (string, `default`: your preferred region)
   - `vpc_cidr` (string, `default`: `"10.0.0.0/16"`)
   - `subnet_cidr` (string, `default`: `"10.0.1.0/24"`)
   - `instance_type` (string, `default`: `"t2.micro"`)
   - `project_name` (string, no `default` -- force the user to provide it)
   - `environment` (string, `default`: `"dev"`)
   - `allowed_ports` (list of numbers, `default`: `[22, 80, 443]`)
   - `extra_tags` (map of strings, `default`: `{}`)

2. I replace every hardcoded value in `main.tf` with `var.<name>` references.
3. Run `terraform plan` -- it should prompt me .for `project_name` since it has no default.

#### What are the five variable types in Terraform? (`string`, `number`, `bool`, `list`, `map`)
* **string:** Stores text values (Example: "t3.micro").
* **number:** Stores numeric integers or decimals (Example: 80, 10.5).
* **bool:** Stores boolean logic, strictly true or false.
* **list:** Stores an ordered sequence of values accessible by an index number (Example: ``).
* **map:** Stores un-ordered key-value pairs used for custom lookups (Example: { Env = "dev" }).

![alt text](<Screenshot From 2026-10-21 14-36-08.png>)

---

## TASK-2
1. I create `terraform.tfvars` file and add:
```hcl
project_name = "terraweek"
environment  = "dev"
instance_type = "t2.micro"
```

2. I create `prod.tfvars` file and add:
```hcl
project_name = "terraweek"
environment  = "prod"
instance_type = "t3.small"
vpc_cidr     = "10.1.0.0/16"
subnet_cidr  = "10.1.1.0/24"
```

3. I Apply with the default file:
```bash
terraform plan                              # Uses terraform.tfvars automatically
```

4. Apply with the prod file:
```bash
terraform plan -var-file="prod.tfvars"      # Uses prod.tfvars
```

5. Override with CLI:
```bash
terraform plan -var="instance_type=t2.nano"  # CLI overrides everything
```

6. Set an environment variable:
```bash
export TF_VAR_environment="staging"
terraform plan                              # env var overrides default but not tfvars
```

#### Write the variable precedence order from lowest to highest priority.
1. **TF_VAR_** env variables (Lowest)
2. **terraform.tfvars** file
3. ***.auto.tfvars** files evaluates alphabetically
4. **-var** or **-var-file** flags on the command line (Highest)

---

## TASK-3
1. I create an **outputs.tf** file with outputs for:

   1. `vpc_id` -- the VPC ID
   2. `subnet_id` -- the public subnet ID
   3. `instance_id` -- the EC2 instance ID
   4. `instance_public_ip` -- the public IP of the EC2 instance
   5. `instance_public_dns` -- the public DNS name
   6. `security_group_id` -- the security group ID

2. I apply your config and verify the outputs are printed at the end:
```bash
terraform apply

# After apply, you can also run:
terraform output                          # Show all outputs
terraform output instance_public_ip       # Show a specific output
terraform output -json                    # JSON format for scripting
```

#### Verify: Does `terraform output instance_public_ip` return the correct IP?
* **YES!** `terraform output instance_public_ip` returns the correct IP

![alt text](<Screenshot From 2026-10-21 15-49-38.png>)

---

## TASK-4
1. I add a `data aws_ami` block that:
   - Filters for Amazon Linux 2 images
   - Filters for `hvm` virtualization and `gp2` root device
   - Uses `owners = ["amazon"]`
   - Sets `most_recent = true`

2. Replace the hardcoded AMI in your `aws_instance` with `data.aws_ami.amazon_linux.id`

3. Add a `data "aws_availability_zones"` block to fetch available AZs in your region

4. Use the first AZ in your subnet: `data.aws_availability_zones.available.names[0]`

#### What is the difference between a `resource` and a `data` source?
* **resource (Write / Create):** Tells Terraform to build, update, or delete real infrastructure inside your cloud account (e.g., launching a brand new EC2 instance).
* **Resource = Create a new item**
* **data (Read / Query):** Tells Terraform to look up and fetch information about infrastructure that already exists outside your current code (e.g., searching the live AWS catalog to find the latest AMI ID).
* **Data = Read an existing item's details**

---

## TASK-5
1. I add a `locals` block:
```hcl
locals {
  name_prefix = "${var.project_name}-${var.environment}"
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
```

2. I replace all Name tags with `local.name_prefix`:
   - VPC: `"${local.name_prefix}-vpc"`
   - Subnet: `"${local.name_prefix}-subnet"`
   - Instance: `"${local.name_prefix}-server"`

3. Merge common tags with resource-specific tags:
```hcl
tags = merge(local.common_tags, {
  Name = "${local.name_prefix}-server"
   }
)
```
![alt text](<Screenshot From 2026-10-21 17-24-40.png>)

* I apply and check the tags in the AWS console -- every resource should have consistent tagging.

![alt text](<Screenshot From 2026-10-21 17-25-37.png>)

---

## TASK-6
I practice these in `terraform console`:
```bash
terraform console
```

1. **String functions:**
   - `upper("terraweek")` -> `"TERRAWEEK"`
   - `join("-", ["terra", "week", "2026"])` -> `"terra-week-2026"`
   - `format("arn:aws:s3:::%s", "my-bucket")`

2. **Collection functions:**
   - `length(["a", "b", "c"])` -> `3`
   - `lookup({dev = "t2.micro", prod = "t3.small"}, "dev")` -> `"t2.micro"`
   - `toset(["a", "b", "a"])` -> removes duplicates

3. **Networking function:**
   - `cidrsubnet("10.0.0.0/16", 8, 1)` -> `"10.0.1.0/24"`

4. **Conditional expression** -- add this to your config:
```hcl
instance_type = var.environment == "prod" ? "t3.small" : "t2.micro"
```

* I apply with `environment = "prod"` and verify the instance type changes.

#### Pick five functions you find most useful and explain what each does.
* upper("value") :- It coverts string from lowercase to UPPERCASE
   - e.g., `upper("terraweek")`
      - **"TERRAWEEK"**
* join("-", [value]) :- It joins all the strings together
   - e.g., `join("-", ["terra", "week", "2026"])`
      - **"terra-week-2026"**
* length([value]) :- It counts the length of the strings
   - e.g., `length(["a", "b", "c"])`
      - **3**
* lookup({map and key}, "env") :- looks up and extracts a value from a map using a specific 
   - e.g., `lookup({dev = "t2.micro", prod = "t3.small"}, "dev")`
      - **t3.micro**
* cidrsubnet("cidr", 8, 1) :- function calculates and carves out a smaller subnet IP range from a larger base network (VPC) range
   - e.g., `cidrsubnet("10.0.0.0/16", 8, 1)`
      - **"10.0.1.0/24"**

![alt text](<Screenshot From 2026-10-21 17-16-14.png>)

---
