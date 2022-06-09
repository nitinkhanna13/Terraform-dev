########################################################################
module "attendance_batches_s3_bucket" {
source  = "cloudposse/s3-bucket/aws"
  version = "v2.0.1"

  bucket_name = "cdh-stest-${var.environment}"

  allow_encrypted_uploads_only = true
  versioning_enabled           = false
  lifecycle_rules = [
    {
      enabled = true
      prefix  = ""
      tags    = {}

      enable_glacier_transition            = false
      enable_deeparchive_transition        = false
      enable_standard_ia_transition        = false
      enable_current_object_expiration     = true
      enable_noncurrent_version_expiration = true

      abort_incomplete_multipart_upload_days         = 5
      noncurrent_version_glacier_transition_days     = 30
      noncurrent_version_deeparchive_transition_days = 60
      noncurrent_version_expiration_days             = 90

      standard_transition_days    = 30
      glacier_transition_days     = 60
      deeparchive_transition_days = 90
      expiration_days             = 90
    }
  ]
}