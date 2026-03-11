locals {
  env = "${terraform.workspace}"
  env_suffix_env = {
    default = "Staging"
    staging = "Staging"
    production = "Production"
  }
  env_suffix = "${lookup(local.env_suffix_env, local.env)}"
}

output "env_suffix" {
  value = "${local.env_suffix}"
}