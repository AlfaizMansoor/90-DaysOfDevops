# Day 64 -- Terraform State Management and Remote Backends
## TASK-1
I Use my previous "Day-63" config, I Applied it and then explore the state:

```bash
terraform show                                    # Full state in human-readable format
terraform state list                              # All resources tracked by Terraform
terraform state show aws_instance.<name>          # Every attribute of the instance
terraform state show aws_vpc.<name>               # Every attribute of the VPC
```

#### How many resources does Terraform track?
* Terraform tracks Total 11 resources
```bash
data.aws_ami.amazon_linux
data.aws_availability_zones.available
aws_instance.my_new_instance
aws_internet_gateway.my_gateway
aws_route_table.my_route_table
aws_route_table_association.my_rt_association
aws_s3_bucket.new_bucket
aws_security_group.my_secure_group
aws_subnet.my_subnet
aws_vpc.main
aws_vpc_security_group_egress_rule.allow_outbound
```

#### What attributes does the state store for an EC2 instance? (hint: way more than what you defined)
```json
{
  "version": 4,
  "terraform_version": "1.17.0",
  "serial": 38,
  "lineage": "ee9ade62-1c89-59e7-6c7e-a2d75b5357ba",
  "outputs": {},
  "resources": [],
  "check_results": null
}
```

#### Open `terraform.tfstate` in an editor -- find the `serial` number. What does it represent?
* serial: 38

---

## TASK-2
1. First, i create the backend infrastructure:
```bash
# Create S3 bucket for state storage
aws s3api create-bucket \
  --bucket terraweek-state-<yourname> \
  --region ap-south-1 \
  --create-bucket-configuration LocationConstraint=ap-south-1

# Enable versioning (so you can recover previous state)
aws s3api put-bucket-versioning \
  --bucket terraweek-state-<yourname> \
  --versioning-configuration Status=Enabled

# Create DynamoDB table for state locking
aws dynamodb create-table \
  --table-name terraweek-state-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region ap-south-1
```

2. I add the backend block to my Terraform config **"terraform.tf"**:
```hcl
terraform {
  backend "s3" {
    bucket         = "terraweek-state-<yourname>"
    key            = "dev/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraweek-state-lock"
    encrypt        = true
  }
}
```

3. I run:
```bash
terraform init
```

4. Verify:
   - Check the S3 bucket -- you should see `dev/terraform.tfstate`
    * **YES!** dev/terraform.tfstate was there.
   - Your local `terraform.tfstate` should now be empty or gone
    * It's empty
   - Run `terraform plan` -- it should show no changes (state migrated correctly)
    ```bash
    No changes. Your infrastructure matches the configuration.

    Terraform has compared your real infrastructure against your configuration and found no differences,
    so no changes are needed.
    ```

![alt text](<Screenshot From 2026-10-21 14-45-10.png>)
![alt text](<Screenshot From 2026-10-24 22-43-50.png>)

---

## TASK-3
* State locking prevents two people from running `terraform apply` at the same time and corrupting the state.

1. I open **two terminals** in the same project directory
2. In Terminal 1, i run:
```bash
terraform apply
```
3. While Terminal 1 is waiting for confirmation, in Terminal 2 i run:
```bash
terraform plan
```
4. Terminal 2 should show a **lock error** with a Lock ID

#### What is the error message? Why is locking critical for team environments?
* In a team environment, state locking is critical because it prevents race conditions, data corruption, and conflicting infrastructure changes when multiple engineers run deployments at the same time.

```bash
│ Error: Error acquiring the state lock
│ 
│ Error message: operation error S3: PutObject, https response error StatusCode: 412,
│ RequestID: FCQK5MX8EGWQXJ3F, HostID:
│ e6pB4tCCSWBc/58QRwAjLjnETsHNF2vKuQN5/ZoEZLXApNG5SvI/p0GXa/2CHY30eoN1a3tKlSOHTEvpCoS+yFVzNjH+e1D/,
│ api error PreconditionFailed: At least one of the pre-conditions you specified did not hold
│ Lock Info:
│   ID:        f7795a1d-5718-63a4-2e56-bb7aa6a2c966
│   Path:      terraweek-state-alfaiz/dev/terraform.tfstate
│   Operation: OperationTypeApply
│   Who:       alfaiz@alfaiz
│   Version:   1.17.0
│   Created:   2026-10-24 17:10:53.7885453 +0000 UTC
│   Info:      
│ 
│ 
│ Terraform acquires a state lock to protect the state from being written
│ by multiple users at the same time. Please resolve the issue above and try
│ again. For most commands, you can disable locking with the "-lock=false"
│ flag, but this is not recommended.
```

![alt text](<Screenshot From 2026-10-24 22-43-04.png>)

5. After the test, if you get stuck with a stale lock:
```bash
terraform force-unlock <LOCK_ID>
```

---

### Task 4: Import an Existing Resource
1. I manually create an S3 bucket in the AWS console -- name it `terraweek-import-test-alfaiz`
2. I Write a `resource "aws_s3_bucket"` block in my config(**"main.tf"**) for this bucket.
3. Import it:
```bash
terraform import aws_s3_bucket.imported terraweek-import-test-alfaiz
```
4. I run `terraform plan`:
   - I see "No changes" -- then the import was perfect
   - If you see changes -- your config does not match reality. Update your config to match, then plan again until you get "No changes"

5. Run `terraform state list` -- the imported bucket should now appear alongside your other resources
```bash
aws_dynamodb_table.my_table
aws_s3_bucket.imported
aws_s3_bucket.new_one
aws_s3_bucket_versioning.bucket_version
```
#### What is the difference between `terraform import` and creating a resource from scratch?
* `terraform import` imports a exixting resources from from AWS management console, where creating a resource from scratch means creating a resource from cli/local using script or HCL languageand terraform.

---

### Task 5: State Surgery -- mv and rm
Sometimes you need to rename a resource or remove it from state without destroying it in AWS.

1. **Rename a resource in state:**
```bash
terraform state list                              # Note the current resource names
terraform state mv aws_s3_bucket.imported aws_s3_bucket.logs_bucket
```
I Update my **"main.tf"** file to match the new name. Run `terraform plan` -- it should show no changes.

2. **Remove a resource from state (without destroying it):**
```bash
terraform state rm aws_s3_bucket.logs_bucket
```
I run `terraform plan` -- Terraform no longer knows about the bucket, but it still exists in AWS.

3. **Re-import it** to bring it back:
```bash
terraform import aws_s3_bucket.logs_bucket terraweek-import-test-alfaiz
```

#### When would you use `state mv` in a real project? When would you use `state rm`?
* `state mv` is used to rename a exixting resource
* `state rm` is used to remove a resources from cli without deleting it permanently from AWS management console
---

### Task 6: Simulate and Fix State Drift
State drift happens when someone changes infrastructure outside of Terraform -- through the AWS console, CLI, or another tool.

1. I applied my full config so everything is in sync
2. then i went to the **AWS console** and manually:
   - I change the Name tag of my EC2 instance to `"ManuallyChanged"`
   - I add a new tag

![alt text](<Screenshot From 2026-10-24 23-49-53.png>)

3. Run:
```bash
terraform plan
```

4. You have two choices:
   - **Option A:** Run `terraform apply` to force reality back to match your config (reconcile)
   - **Option B:** Update your `.tf` files to match the manual change (accept the drift)
* I choose **Option B** manually change the **"main.tf"** according to the changes i made on AWS management console

5. I choose Option A -- apply and verify the tags are restored.

6. I run `terraform plan` again -- it should show "No changes." Drift resolved.

![alt text](<Screenshot From 2026-10-24 23-50-57.png>)

#### How do teams prevent state drift in production? (hint: restrict console access, use CI/CD for all changes)
* In production environments, teams prevent state drift (the disconnect between what is defined in code and what actually exists in the cloud) by enforcing a strict "Code-as-Truth" operational framework.

* If engineers are allowed to log into the AWS Console and manually click buttons to change configurations, your Git repository instantly becomes obsolete, and security compliance breaks down.

* Teams use a combination of automated pipelines, security restrictions, and continuous monitoring to maintain synchronization:

---