# Day 65 -- Terraform Modules: Build Reusable Infrastructure
## TASK-1
File structure:

```bash
terraform-modules/
  main.tf                    # Root module -- calls child modules
  variables.tf               # Root variables
  outputs.tf                 # Root outputs
  providers.tf               # Provider config
  modules/
    ec2-instance/
      main.tf                # EC2 resource definition
      variables.tf           # Module inputs
      outputs.tf             # Module outputs
    security-group/
      main.tf                # Security group resource definition
      variables.tf           # Module inputs
      outputs.tf             # Module outputs
```

* I create all the directories and empty files. This is the standard layout every Terraform project follows.

#### What is the difference between a "root module" and a "child module"?
* Root Module: Exactly one per application. It bootstraps global settings, sets up core configurations, and directs overall execution flow.
* Child Module: One of many optional sub-units. It contains specific feature logic or reusable utilities and relies on the root module to be executed.

---

## TASK-2
Create `modules/ec2-instance/`:

1. **"variables.tf"** -- define inputs:
   - `ami_id` (string)
   - `instance_type` (string, default: `"t2.micro"`)
   - `subnet_id` (string)
   - `security_group_ids` (list of strings)
   - `instance_name` (string)
   - `tags` (map of strings, default: `{}`)

2. **"main.tf"** -- define the resource:
   - `aws_instance` using all the variables
   - Merge the Name tag with additional tags

3. **"outputs.tf"** -- expose:
   - `instance_id`
   - `public_ip`
   - `private_ip`

---

## TASK-3

I create **"modules/security-group/"**:

1. **"variables.tf"** -- define inputs:
   - `vpc_id` (string)
   - `sg_name` (string)
   - `ingress_ports` (list of numbers, default: `[22, 80]`)
   - `tags` (map of strings, default: `{}`)

2. **"main.tf"** -- define the resource:
   - `aws_security_group` in the given VPC
   - Use `dynamic "ingress"` block to create rules from the `ingress_ports` list
   - Allow all egress

3. **"outputs.tf"** -- expose:
   - `sg_id`

This is your first time using a `dynamic` block -- it loops over a list to generate repeated nested blocks.

---

## TASK-4
In the root **"main.tf"**, wire everything together:

1. I create a VPC and subnet directly.
2. I call the security group module:

```hcl
module "web_sg" {
  source        = "./modules/security-group"
  vpc_id        = aws_vpc.main.id
  sg_name       = "terraweek-web-sg"
  ingress_ports = [22, 80, 443]
  tags          = local.common_tags
}
```

3. Call the EC2 module -- deploy **two instances** with different names using the same module:
```hcl
module "web_server" {
  source             = "./modules/ec2-instance"
  ami_id             = data.aws_ami.amazon_linux.id
  instance_type      = "t2.micro"
  subnet_id          = aws_subnet.public.id
  security_group_ids = [module.web_sg.sg_id]
  instance_name      = "terraweek-web"
  tags               = local.common_tags
}

module "api_server" {
  source             = "./modules/ec2-instance"
  ami_id             = data.aws_ami.amazon_linux.id
  instance_type      = "t2.micro"
  subnet_id          = aws_subnet.public.id
  security_group_ids = [module.web_sg.sg_id]
  instance_name      = "terraweek-api"
  tags               = local.common_tags
}
```

4. I add root outputs that reference module outputs:
```hcl
output "web_server_ip" {
  value = module.web_server.public_ip
}

output "api_server_ip" {
  value = module.api_server.public_ip
}
```

5. Apply:

```bash
terraform init    # Downloads/links the local modules
terraform plan    # Should show all resources from both module calls
terraform apply
```

#### **Verify:** Two EC2 instances running, same security group, different names. Check the AWS console.
* **YES!** All EC2 instances are running on same security group, and different name

![alt text](<Screenshot From 2026-10-25 20-05-05.png>)
---

## TASK-5
Instead of building my own VPC from scratch, i use the official module from the Terraform Registry.

1. I replace my hand-written VPC resources with:
```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "terraweek-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["ap-south-1a", "ap-south-1b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]

  enable_nat_gateway = false
  enable_dns_hostnames = true

  tags = local.common_tags
}
```

2. I update my EC2 and SG module calls to reference `module.vpc.vpc_id` and `module.vpc.public_subnets[0]`

3. Run:
```bash
terraform init     # Downloads the registry module
terraform plan
terraform apply
```

4. Compare: how many resources did the VPC module create vs your hand-written VPC from Day 62?
* VPC module create total 21 resources while in my Hand-written VPC from day-62 there'are total 5 resources created

```bash
data.aws_ami.amazon_linux
module.api_server.aws_instance.new_server_instance
module.vpc.aws_default_network_acl.this[0]
module.vpc.aws_default_route_table.default[0]
module.vpc.aws_default_security_group.this[0]
module.vpc.aws_internet_gateway.this[0]
module.vpc.aws_route.public_internet_gateway[0]
module.vpc.aws_route_table.private[0]
module.vpc.aws_route_table.private[1]
module.vpc.aws_route_table.public[0]
module.vpc.aws_route_table_association.private[0]
module.vpc.aws_route_table_association.private[1]
module.vpc.aws_route_table_association.public[0]
module.vpc.aws_route_table_association.public[1]
module.vpc.aws_subnet.private[0]
module.vpc.aws_subnet.private[1]
module.vpc.aws_subnet.public[0]
module.vpc.aws_subnet.public[1]
module.vpc.aws_vpc.this[0]
module.web_server.aws_instance.new_server_instance
module.web_sg.aws_security_group.my_group
```

#### Where does Terraform download registry modules to? Check `.terraform/modules/`.
* Terraform downloads module to the path **".terraform/modules/modules.json"** it is a .json file which stores created or downloaded modules in it.

```json
{"Modules":[{"Key":"","Source":"","Dir":"."},{"Key":"api_server","Source":"./modules/ec2-instance","Dir":"modules/ec2-instance"},{"Key":"vpc","Source":"registry.terraform.io/terraform-aws-modules/vpc/aws","Version":"5.21.0","Dir":".terraform/modules/vpc"},{"Key":"web_server","Source":"./modules/ec2-instance","Dir":"modules/ec2-instance"},{"Key":"web_sg","Source":"./modules/security-group","Dir":"modules/security-group"}]}
```

---

## TASK-6
1. Pin your registry module version explicitly:
   - `version = ">= 5.0, < 6.0"` -- range

![alt text](<Screenshot From 2026-10-25 21-09-48.png>)

2. Run `terraform init -upgrade` to check for newer versions

3. Check the state to see how modules appear:
```bash
terraform state list
```
Notice the `module.vpc.`, `module.web_server.`, `module.web_sg.` prefixes.

4. Destroy everything:
```bash
terraform destroy
```

#### Write down five module best practices:
- **Always pin versions for registry modules** to prevent unexpected breaking changes from automated external updates.
- **Keep modules focused -- one concern per module** to ensure reusability, easy testing, and simple maintainance.
- **Use variables for everything, hardcode nothing** so that configurations remain completely flexible across multiple environments.
- **Always define outputs so callers can reference resources** and pass necessary data smoothly downstream to other elements.
- **Add a README.md to every custom module** to clearly document input variables, outputs, and usage blueprints for your team.

---
