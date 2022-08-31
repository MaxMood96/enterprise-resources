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
- Statsd/grafana/prometheus (if enabled)

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


## ALB Ingress Controller
By default, this template will deploy the [aws-load-balancer-controller](https://github.com/kubernetes-sigs/aws-load-balancer-controller) to create an ingress for Codecov. This will work out of the box but if you prefer to use your own ingress solution (emissary/nginx/traefik) this can be disabled by:
```terraform
#Set this in both cluster and k8s-config.
ingress_enabled=false
```

## DNS
It is recommended to let this template handle DNS for you. If your DNS is hosted in route53, all you need to do is:
```terraform
#Set this in both cluster and k8s-config.
dns_enabled=true
hosted_zone_id=ID_FROM_ROUTE_53
```
This will do ACM cert validation for you in addition to creating a record for Codecov for the `ingress_host` that you specify.


Sometimes, your route53 zones are located in other AWS accounts. This is accommodated by allowing a profile for this account to be specified for the route53 account.
```terraform
#Set this in both cluster and k8s-config.
route53_profile="your_profile_that_manages_route53"
route53_region="us-east-1" #this is the default
```
If you do not specify a route53 profile it will use the current one.  
  
On your first run of the k8s-config state it will likely fail due to the ALB controller not having a dns name yet. This is fine. You simply need to run another apply after about a minute. The second run will look like the below output. If you choose not to let this template manage your DNS, the ingress_hostname that is output will be the value you use with a CNAME in your DNS provider.
```shell
aws_route53_record.record[0]: Creating...
aws_route53_record.record[0]: Still creating... [10s elapsed]
aws_route53_record.record[0]: Still creating... [20s elapsed]
aws_route53_record.record[0]: Still creating... [30s elapsed]
aws_route53_record.record[0]: Still creating... [40s elapsed]
aws_route53_record.record[0]: Creation complete after 42s [id=ZONEID_YOUR_INGRESS_HOST.YOUR_DOMAIN_CNAME]

Apply complete! Resources: 1 added, 1 changed, 0 destroyed.

Outputs:

ingress_hostname = "k8s-codecov-codecovi-ID.us-gov-east-1.elb.amazonaws.com"

```
## EKS Console View

EKS by default only gives cluster rbac permissions to the AWS user who provisions the cluster.   
If you wish to view/manage the cluster with other users you can provide a list of management users:
```terraform
#Set this in k8s-config
management_users=["Administrator"]
```
Once your user has permissions, you can additionally obtain a kubeconfig entry by running:
```shell
aws eks update-kubeconfig --region YOUR_REGION --name codecov-cluster
```
That way you can manage your cluster with kubectl/k9s/lens or the tool of your choice.


## Metrics

By default, this template will deploy a metrics stack (grafana/statsd/prometheus) to monitor Codecov. If using the ALB ingress controller from this template then these will be available at `CODECOV_URL/grafana`, `CODECOV_URL/prometheus`.
This is released currently in a beta state. There may be some issues that arise and we encourage you to file issues on this repo.

## Best practices for Terraform and Codecov

This is intended to be an example terraform stack.  As such, it ignores some
terraform best practices such as remote state storage and locking.  For more
info on running a robust terraform stack see [Terraform Recommended
Practices](https://www.terraform.io/docs/enterprise/guides/recommended-practices/index.html).

Please review Codecov [Self-hosted Best
Practices](https://docs.codecov.io/docs/best-practices) as well.

## Destroying

If you want to remove your Codecov Enterprise stack, execute `terraform
destroy` in both templates, starting with k8s-config.  *This will remove all of your enterprise configuration and uploaded
coverage reports.*  All resources created with terraform will be removed, so
please use with caution.

