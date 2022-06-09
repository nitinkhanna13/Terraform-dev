#####################################################################
module "testuser" {
  source = "cloudposse/iam-user/aws"
  # Cloud Posse recommends pinning every module to a specific version
  version              = "v0.8.1"
  user_name             = "test.user"
  pgp_key               = false
  login_profile_enabled = false
}

output "USERNAME" {
  value = module.testuser.user_name
}


#########################################################################

module "cdh" {
  source = "cloudposse/iam-user/aws"
  # Cloud Posse recommends pinning every module to a specific version
  version              = "v0.8.1"
  user_name             = "cdh.user"
  pgp_key               = false
  login_profile_enabled = false
}

output "cdhuser" {
  value = module.cdh.user_name
}



#################################################


module "tftest" {
  source = "cloudposse/iam-user/aws"
  # Cloud Posse recommends pinning every module to a specific version
  version              = "v0.8.1"
  user_name             = "cdh.terraform"
  pgp_key               = false
  login_profile_enabled = false
}

output "tftest" {
  value = module.cdh.user_name
}



#############################################################


module "lsac-user" {
  source = "cloudposse/iam-user/aws"
  # Cloud Posse recommends pinning every module to a specific version
  version              = "v0.8.1"
  user_name             = "lsac.user.test"
  pgp_key               = false
  login_profile_enabled = false
}

output "lsac-user" {
  value = module.lsac-user.user_name
}
