# Codecov Extra Secret Volume Example

This is meant to be a quick, mostly nonfunctional example of how to include extra secret volumes as variables. These variables work with each of the cloud provider templates or with the [standalone codecov module](../../terraform-k8s-codecov).

```terraform
extra_secret_volumes = {
  gh = {
    mount_path = "/gh"
    file_name = "codecov.pem"
    local_path = "/secrets/codecov.pem"
  }
  scm = {
    mount_path = "/cert"
    file_name = "scm_ca_cert.pem"
    local_path = "/secrets/CA.pem"
  }
}
```

The above format is how to include arbitrary files into the Codecov pods. The `local_path` is expected to map to a local file that terraform can find. The `mount_path` is where k8s will mount the file and the `file_name` is the name of the file k8s will use. In this example, we are adding a pem file for a github app integration and a scm ca cert for self signed ssl with github enterprise [docs](https://docs.codecov.com/docs/set-up-oauth-login#include-sslpem-for-self-signed-ssl).

This yaml snippet would be the corresponding config to include in your codecov.yml file. More info in the [docs](https://docs.codecov.com/docs/how-to-create-a-github-app-for-codecov-enterprise#generate-and-add-a-pem-file-to-codecov).
```yaml
github_enterprise:
    ssl_pem: /cert/scm_ca_cert.pem # only needed if doing self signed ssl
    integration: 
        id: 1234
        pem: /gh/codecov.pem
```