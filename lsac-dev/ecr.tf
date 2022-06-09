module "test-ecr" {
  source = "cloudposse/ecr/aws"
  # Cloud Posse recommends pinning every module to a specific version
  version                 = "v0.34.0"
  name                    = "cdh/test-ecr"
  use_fullname            = false
  regex_replace_chars     = "/[^a-zA-Z0-9-/]/"
  enable_lifecycle_policy = false
  encryption_configuration = {
    encryption_type = "AES256"
    kms_key         = null
  }
}

output "repository_name" {
  value = module.test-ecr.repository_name
}

######################################################################################
module "alpha" {
  source = "cloudposse/ecr/aws"
  # Cloud Posse recommends pinning every module to a specific version
  version   = "v0.34.0"
  namespace = "automlrepository"
  #delimiter               = "/"
  #stage                  = "test"
  #name                    = "cdh-apps"
  enable_lifecycle_policy = false
}
output "alpha-images" {
  value = module.alpha.repository_name
}
##########################################################################################
