# Azure Kubernetes Service Example

This is an example Codecov stack deployed to Azure Kubernetes Service via
terraform.  It consists of:
- A Kubernetes Service cluster
- A Postgres instance
- A Redis instance
- A storage account for coverage report storage.

This stack will get you started with a fully functional Codecov enterprise
stack, but we suggest you review 
[Best practices for Terraform and Codecov](#best-practices-for-terraform-and-codecov) 
for a fully robust deployment.

## Getting Started

- Install the Azure [az
  cli](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
  tool.
- Log in with the Azure cli tool: `az login`
- Create an Active Directory service principal:
    ```shell
    SUBSCRIPTION_ID=$(az account show | grep id | cut -d ':' -f 2 | tr -d '",')
    az ad sp create-for-rbac --role="Contributor" \
        --scopes="/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    ```
  Save the output of this command, these credentials will be needed to
  configure the Azure provider and Kubernetes cluster.
- Export the following variables using your `~/.bash_profile`/`~/.zprofile` or a tool
  like [direnv](https://direnv.net/).  After the kubernetes cluster is
  created, a .kubeconfig file will be created in the current directory for use
  with `kubectl`.  For more information, see [Configuring the Service Principal in
  Terraform](https://www.terraform.io/docs/providers/azurerm/auth/service_principal_client_secret.html#configuring-the-service-principal-in-terraform).
    ```
    export ARM_CLIENT_ID="appId from the above output"
    export ARM_CLIENT_SECRET="password from the above output"
    export ARM_SUBSCRIPTION_ID="the subscription ID you used to create the SP"
    export ARM_TENANT_ID="tenant from the above output"
    export KUBECONFIG=.kubeconfig
    ```
- For more information on this and other ways to configure access for the `azurerm`
  provider, see [Azure Provider](https://www.terraform.io/docs/providers/azurerm/index.html)
  in the terraform documentation.
- You will need a DNS A record to assign to the load balancer address (ex:
  `codecov.yourdomain.com`).  Instructions on how to set this up are below in
  the [Executing terraform](#executing-terraform) section.

## Codecov configuration

Configuration of Codecov enterprise is handled through a YAML config file.
See [configuring codecov.yml](https://docs.codecov.io/docs/configuration) for 
more info.  Refer to this example [codecov.yml](../codecov.yml.example) for the
minimum necessary configuration.

The terraform stack is configured using terraform variables which can be
defined in a `terraform.tfvars` file.  More info on
[Terraform input variables](https://www.terraform.io/docs/configuration/variables.html).

Detailed variable options are presented in each sub template readme.

### Instance Types

The default node pool VM size and number of instances are the minimum to get
the Codecov application up and running.  Tuning these will be required,
dependent on your specific use-case.


### Granting Codecov access to internal resources

If your organization requires creating firewall rules to grant Codecov access
to your internal resources, the IP address for the NAT gateway can be found in
the terraform output as `egress-ip`.  All requests from Codecov Enterprise 
will originate from this address.

## Executing terraform

After configuring `codecov.yml` and `terraform.tfvars` you are ready to execute
terraform in first the cluster folder and then in the k8s-config folder which will create 
the stack following these steps:

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
     
     ingress-lb-ip = xxx.xxx.xxx.xxx
     ```
5. The ingress IP and minio API keys are output at the end of the run.
   If you are manageing your own dns: Create a DNS A record for the `ingress_host` and `minio_host` pointing at the
   resulting `ingress-lb-ip`. If you are using the certmanager feature the dns record needs created
    before the certificate will be successfully issued

## DNS
It is recommended to let this template handle DNS for you. If your DNS is hosted in Azure, all you need to do is:
```terraform
#Set this in k8s-config.
dns_enabled=true
dns_zone=NAME_OF_ZONE_IN_AZURE
domain=ROOT_DNS_ZONE # eg example.com if you want dns set to codecov.example.com
```
This template will create a minio dns record as well in the format `minio.${domain}` with the domain from the variables above. If you choose to manage your own dns, this still will need to be set and the minio record created.

## Destroying

If you want to remove your Codecov Enterprise stack, execute `terraform
destroy`.  *This will remove all of your enterprise configuration and uploaded
coverage reports.*  All resources created with terraform will be removed, so
please use with caution.

## Best practices for Terraform and Codecov

This is intended to be an example terraform stack.  As such, it ignores some
terraform best practices such as remote state storage and locking.  For more
info on running a robust terraform stack see [Terraform Recommended
Practices](https://www.terraform.io/docs/enterprise/guides/recommended-practices/index.html).

Please review Codecov [Self-hosted Best
Practices](https://docs.codecov.io/docs/best-practices) as well.
