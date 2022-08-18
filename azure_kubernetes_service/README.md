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
    ```
    az ad sp create-for-rbac --role="Contributor" \
        --scopes="/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    ```
  Save the output of this command, these credentials will be needed to
  configure the Azure provider and Kubernetes cluster.
- Export the following variables using your `~/.bash_profile` or a tool
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
more info.  Refer to this example [codecov.yml](codecov.yml.example) for the
minimum necessary configuration.

The terraform stack is configured using terraform variables which can be
defined in a `terraform.tfvars` file.  More info on
[Terraform input variables](https://www.terraform.io/docs/configuration/variables.html).

| name | description                                          | default                                                              |
| --- |------------------------------------------------------|----------------------------------------------------------------------|
| `location` | Azure location                                       | eastus            in cluster folder                                                  |
| `azurerm_client_id` | `appId` from the SP creation output                  |             in cluster folder                    |
| `azurerm_client_secret` | `password` from the SP creation output               |          in cluster folder                     |
| `codecov_version` | Version of codecov enterprise to deploy*             | latest-stable                         |
| `cluster_name` | Azure Kubernetes Service (AKS) cluster name          | default-codecov-cluster                  |
| `node_pool_count` | Number of nodes to configure in the node pool        | 5                                     |
| `node_pool_vm_size` | VM size to use for node pool nodes                   | Standard_B2s                                                         |
| `postgres_sku` | PostgreSQL SKU (instance size and type)              | GP_Gen5_2                                                            |
| `postgres_storage_profile` | PostgreSQL size and type of disk storage             | See `variables.tf`                                                   |
| `web_resources` | Map of resources for web k8s deployment              | See `variables.tf` See `variables.tf` in cluster folder              |
| `worker_resources` | Map of resources for worker k8s deployment           | See `variables.tf`        in cluster folder                           |
| `minio_resources` | Map of resources for minio k8s deployment            | See `variables.tf`         in cluster folder                         |
| `codecov_yml` | Path to your codecov.yml                             | see codecov.yml                                                      |
| `enable_certmanager` | enables letsencrypt certificates                     | See `variables.tf` in k8s-config folder                              |
| `enable_external_tls`  | enables use of local certificate                     | See `variables.tf` in k8s-config folder                              |
| `tls_key` | Path to private key to use for TLS                   | required if external_tls=1  See `variables.tf` in k8s-config folder  |
| `tls_cert` | Path to certificate to use for TLS                   | required if external_tls=1   See `variables.tf` in k8s-config folder |
| `ssh_public_key` | SSH public key path, used for the Kubernetes cluster |                                                                      |
| `resource_tags` | Map of tags to include in compatible resources       | `{application=codecov, environment=test}`                            |
| `scm_ca_cert` | Optional SCM CA certificate path in PEM format       |                                                                      |
\* Specifying a codecov_version is recommended and requires the format `v$VERSION` e.g. `v4.5.8`

### `scm_ca_cert`

If `scm_ca_cert` is configured, it will be available to Codecov at
`/cert/scm_ca_cert.pem`.  Include this path in your `codecov.yml` in the scm
config.

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
   Create a DNS A record for the `ingress_host` above pointing at the
   resulting `ingress-lb-ip`. If you are using the certmanager feature the dns record needs created
    before the certificate is issued

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
