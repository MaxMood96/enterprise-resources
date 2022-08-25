# Codecov EKS

This is an example Codecov stack deployed to AWS Elastic Kubernetes Service via
terraform.  It consists of:
- A VPC
- Public and private subnets spanning for each of 3 availability zones.
- An EKS kubernetes cluster
- An RDS Postgres instance
- An Elasticache Redis instance
- An S3 bucket for coverage report storage.
- Kubernetes resources for Codecov
- DNS (if enabled)
- ACM cert (if enabled)

This stack will get you started with a fully functional Codecov enterprise
stack, but we suggest you review 
[Best practices for Terraform and Codecov](#best-practices-for-terraform-and-codecov) 
for a fully robust deployment.

## Getting Started

- Install the [aws
  cli](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html)
  tool.
- Create a new [IAM
  user](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html).
- Attach the [AdministratorAccess
  policy](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_job-functions.html#jf_administrator) to your newly created user.
- [Create access
  keys](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html?icmpid=docs_iam_console)
  for your IAM user.
- [Configure your aws
  cli](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html#cli-quick-configuration) 
  to use the above access keys.  It is recommended to install these keys in
  a profile (ex: `aws configure --profile codecov`).
- Export the AWS_PROFILE variable using your `~/.bash_profile` or a tool
  like [direnv](https://direnv.net/).
    ```
    export AWS_PROFILE=codecov
    ```
- You will need a DNS CNAME to assign to the load balancer address (ex:
  `codecov.yourdomain.com`).  Instructions on how to set this up are below in
  the [Executing terraform](#executing-terraform) section.

## Codecov configuration

Configuration of Codecov enterprise is handled through a YAML config file.
See [configuring codecov.yml](https://docs.codecov.io/docs/configuration) for 
more info.  Refer to this example [codecov.yml](codecov.yml.example) for the
minimum necessary configuration.

The terraform stack is configured using terraform variables which can be
defined in a `terraform.tfvars` file.  More info on
[Terraform input variables](https://www.terraform.io/docs/configuration/variables.html).


## Executing terraform

This is a 2 part terraform template due to limitations of terraform. The kubernetes run must be separate from the EKS create. Part 1 is the cluster. You will perform the below steps in the cluster directory. Upon success run the same steps in the k8s-config directory.

After configuring `codecov.yml` and `terraform.tfvars` you are ready to execute
terraform and create the stack following these steps:

1. Run `terraform init`.  This will download the necessary provider modules and
   prepare your terraform environment for execution.  [Terraform
   init](https://www.terraform.io/docs/commands/init.html)
2. Create a plan: `terraform plan -out=plan.out`.  This checks the current
   state and saves an execution plan to `plan.out`.  [Terraform
   plan](https://www.terraform.io/docs/commands/plan.html)
3. If you're satisfied with the execution plan, apply it.  `terraform apply
   plan.out`.  This will begin creating your stack.  [Terraform
   apply](https://www.terraform.io/docs/commands/apply.html)
4. Wait... this will take a little while.  If everything goes well, you will
   see something like this:
     ```
     [...]
     
     Apply complete! Resources: 36 added, 0 changed, 0 destroyed.
     Outputs:
     
     ingress_hostname = xxxx.elb.amazonaws.com
     ```

* The ingress hostname are output at the end of the k8s-config run. If you have `dns_enabled=true`, then you should have working dns. If not: 
   Create a DNS CNAME record for the `ingress_host` above pointing at the
   resulting `iingress_hostname`.  

## Destroying

If you want to remove your Codecov Enterprise stack, execute `terraform
destroy` in both templates, starting with k8s-config.  *This will remove all of your enterprise configuration and uploaded
coverage reports.*  All resources created with terraform will be removed, so
please use with caution.

## Best practices for Terraform and Codecov

This is intended to be an example terraform stack.  As such, it ignores some
terraform best practices such as remote state storage and locking.  For more
info on running a robust terraform stack see [Terraform Recommended
Practices](https://www.terraform.io/docs/enterprise/guides/recommended-practices/index.html).

Please review Codecov [Self-hosted Best
Practices](https://docs.codecov.io/docs/best-practices) as well.
