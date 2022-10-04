// Example extra volume for GH App pem and SCM CA Cert
extra_secret_volumes = {
  gh = {
    mount_path = "/gh"
    file_name  = "codecov.pem"
    local_path = "/secrets/codecov.pem"
  }
  scm = {
    mount_path = "/cert"
    file_name  = "scm_ca_cert.pem"
    local_path = "/secrets/CA.pem"
  }
}

extra_env = {
  SOME_EXTRA_ENV_YOU_WANT = "VALUE_FOR_ENV"
}