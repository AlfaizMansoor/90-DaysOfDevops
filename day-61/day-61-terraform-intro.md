# Day 61 -- Introduction to Terraform and Your First AWS Infrastructure
## TASK-1

* Before touching the terminal, research and write short notes on:

#### What is Infrastructure as Code (IaC)? Why does it matter in DevOps?
* **Infrastructure as Code (IaC) :** Managing and provisioning Computer-networks, Virtual machines, Databases, and Connection paths using machine readable configuration HCL file which automates tasks instead of clicking buttons.

 * **Why does it matters in DevOps:** IaC is a foundational pillar, it fills the gap between developers and operations, infrastructure configurations are application like code. It automate testing, and seamlessly embed infrastructure deployments directly into CI/CD pipelines, heavily accelerating software delivery lifecycles.

#### What problems does IaC solve compared to manually creating resources in the AWS console?
* **Eliminates Configuration Drift :** Manual edits cause staging and production environments to drift apart over time, creating hidden bugs. IaC guarantees 100% environment parity by deploying from the exact same file

* **Prevents Costly Human Errors :** Prevents Costly Human Errors: Accidentally picking an oversized server instance or leaving database ports wide open to the public internet is easy to do in a browser. IaC enforces peer code reviews and automated security testing before changes go live.

* **Accelerates Scalability :** Setting up complex architectures (VPCs, firewalls, load balancers) manually takes hours or days. IaC does it in seconds and lets you duplicate entire corporate datacenters with one command.

* **Simplifies Clean-up :** Forgetting to turn off a manual test resource can result in surprise cloud bills. IaC cleans up everything completely with a single terminal hook (terraform destroy).

#### How is Terraform different from AWS CloudFormation, Ansible, and Pulumi?
* **AWS CloudFormation :** AWS CloudFormation only works within AWS only, while Terraform is open-source and works across the different cloud platforms.

* **Ansible :** Ansible is a Configuration Management tool meant to log into already-existing servers to install software, copy files, and run application packages, while Terraform is an Infrastructure Provisioning tool used to built core architectural element like :- Networks, databases and etc. from Scratch.

* **Pulumi :** Pulumi lets you build infrastructure using standard programming languages like TypeScript, Python, and Go, while Terraform requires you to learn a custom domain-specific language called HCL (HashiCorp Configuration Language).

#### What does it mean that Terraform is "declarative" and "cloud-agnostic"?
* **Declarative** in which we write code that defines only the desired final state of your infrastructure. You do not write step-by-step instructions on how to build it.
    - **Ex :- Declarative (Terraform):** *"I want an EC2 instance attached to this security group."*

* **Cloud-Agnostic :** Terraform is completely vendor-neutral. It is not locked into a single cloud provider like AWS CloudFormation is locked into AWS.
    - **Ex :- Cloud-Agnostic:** *"Terraform can talk to AWS, Azure, Google Cloud, Kubernetes, Cloudflare, and GitHub"*


## TASK-2
1. Install Terraform:
    ```bash
    # macOS
    brew tap hashicorp/tap
    brew install hashicorp/tap/terraform

    # Linux (amd64)
    wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update && sudo apt install terraform

    # Windows
    choco install terraform
    ```

2. Verify:
    ```bash
    terraform --version
    ```

3. Install and configure the AWS CLI:
    ```bash
    # Install AWS cli and set 
    curl "https://amazonaws.com" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    
    # configure aws by using access keys
    aws configure
    ```
* Enter your Access Key ID, Secret Access Key, default region (e.g., ap-south-1), output format (json)

4. Verify AWS access:
    ```bash
    aws sts get-caller-identity
    {
    "UserId": "AIDAW3RB5AAOXBTP#####",
    "Account": "47144376####",
    "Arn": "arn:aws:iam::47144376####:user/Alfaiz-mansoor"
    }
    ```
    
## TASK-3
1. I create a project directory to write my first Terraform config:
    ```bash
    mkdir terraform-basics && cd terraform-basics
    ```
2. I create a file called **"main.tf"** with:
    1. A terraform block with required_providers specifying the aws provider
    2. A provider `"aws"` block with your region
    3. A resource `"aws_s3_bucket"` that creates a bucket with a globally unique name

3. Run the Terraform lifecycle:
    ```bash
    terraform init      # Download the AWS provider
    terraform plan      # Preview what will be created
    terraform apply     # Create the bucket (type 'yes' to confirm)
    ```

* I went to the AWS S3 console and verify that my bucket exists.

#### Document: What did terraform init download? What does the .terraform/ directory contain?
* `terraform init` downloads the main **".terraform"** file then **"terrafor.tfstate"** and a backup file **"terraform.tfstate"**

* .terraform/ folder is your project's local dependency cache. It contains three things:
    - Provider Binaries: The downloaded cloud connector plugins.
    - Module Cache: Local copies of any external infrastructure templates imported by the user from GitHub or the Terraform registry.
    - Backend Settings: The network mapping data telling Terraform how to find remote state file.

![alt text](<Screenshot From 2026-10-19 20-04-20.png>)

## TASK-4
* In the same **"main.tf"**, add:
1. A resource `aws_instance` using AMI.
2. I set instance type to *"t2.micro"* (I use "t3.micro" instead of t2.micro because my free tier plan eligible for "t2.micro")
3. I add a tag: `Name = "TerraWeek-Day1"`

* Run:
    ```bash
    terraform plan 
    terraform apply
    ```

#### Document: How does Terraform know the S3 bucket already exists and only the EC2 instance needs to be created?
* Terraform knows exactly what to do because of a tracking file called terraform.tfstate 
* State file stores records of every terraform configuration we create, when we applies terraform it checks the file if the given data exists.

![alt text](<Screenshot From 2026-10-19 21-08-23.png>)

## TASK-5
* Terraform tracks everything it creates in a state file. Time to inspect it.

1. I Open **"terraform.tfstate"** in my editor -- i read the JSON structure
2. Run these commands and document what each returns:
    ```bash
    terraform show                          # Human-readable view of current state
    terraform state list                    # List all resources Terraform manages
    terraform state show aws_s3_bucket.<name>   # Detailed view of a specific resource
    terraform state show aws_instance.<name>
    ```
#### What information does the state file store about each resource?
* Resource Mappings
* Metadata
* Attributes
* Sensitive Secrets

#### Why should you never manually edit the state file?
* Manually editing stateful file can corrupts memory, Changing a single character or bracket breaks the JSON structure, causing Terraform to lose its tracking memory completely.

* Causes State Mismatch: Direct edits create a mismatch between what Terraform thinks exists and what actually exists on AWS, leading to crashed deployments.

#### Why should the state file not be committed to Git?
* It contains Secrets if we push it then secrets exposed to public

## TASK-6
1. I change the EC2 instance tag from *"TerraWeek-Day1"* to *"TerraWeek-Modified"* in my main.tf
2. Run terraform plan and read the output carefully:
    - What do the ~, +, and - symbols mean?
        - **+** (Create): Terraform will build a brand new resource from scratch.
        - **~** (Update): Terraform will modify settings on an existing resource without deleting it.
        - **-** (Destroy): Terraform will completely delete the resource from your cloud account.
        - **-/+** (Replace): Terraform must delete the old resource first and create a new one because the requested change cannot be updated live.

    - Is this an in-place update or a destroy-and-recreate?
        - this is an in-place update not destroy-and-recreate
3. Apply the change
4. Verify the tag changed in the AWS console
5. Finally, destroy everything:
    ```bash
    terraform destroy
    ```
    
![alt text](<Screenshot From 2026-10-19 21-23-31.png>)

#### Verify in the AWS console -- both the S3 bucket and EC2 instancce should be gone
* **YES!** both S3 bucket and EC2 Instance are terminated/gone

#### What each Terraform command does (init, plan, apply, destroy, show, state list)
1. **terraform init:*** Downloads plugins and prepares the workspace.
2. **terraform plan:** Previews changes (+, ~, -) before deploying.
3. **terraform apply:** Builds/updates your real cloud infrastructure.
4. **terraform destroy:** Deletes all managed cloud resources.
5. **terraform show:** Displays full details of your current infrastructure.
6. **terraform state list:** Lists names of all tracked resources.