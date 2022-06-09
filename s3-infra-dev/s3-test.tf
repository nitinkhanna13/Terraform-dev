# variable "activity_log_level" {
#   type    = string
#   default = "INFO"
# }

# variable "attendance_batches_bucket_name" {
#   description = "Bucket to store the resources"
#   default     = "gce-lms-attendance-batches"
# }

# variable "lambda_default_date" {
#   type        = string
#   description = "Lambda default date to process data"
#   default     = "2021-07-25"
# }

# variable "attendance_batches_bucket_expiration" {
#   description = "Bucket expiration in days to expunge objects."
#   default     = 180
# }

# // MODULES
# ################################################################################
# module "label-activity" {
#   source  = "cloudposse/label/null"
#   version = "0.25.0"

# #   context   = module.label-new.context
#   namespace = "activity"
# }

# module "attendance_batches_s3_bucket" {
#   source  = "cloudposse/s3-bucket/aws"
#   version = "v2.0.1"

# #   context     = module.label-activity.context
#   bucket_name = "${var.attendance_batches_bucket_name}-${var.environment}"

#   allow_encrypted_uploads_only = true
#   versioning_enabled           = false
#   lifecycle_rules = [
#     {
#       enabled = true
#       prefix  = ""
#       tags    = {}

#       enable_glacier_transition            = false
#       enable_deeparchive_transition        = false
#       enable_standard_ia_transition        = false
#       enable_current_object_expiration     = true
#       enable_noncurrent_version_expiration = true

#       abort_incomplete_multipart_upload_days         = 5
#       noncurrent_version_glacier_transition_days     = 30
#       noncurrent_version_deeparchive_transition_days = 60
#       noncurrent_version_expiration_days             = 90

#       standard_transition_days    = 30
#       glacier_transition_days     = 60
#       deeparchive_transition_days = 90
#       expiration_days             = var.attendance_batches_bucket_expiration
#     }
#   ]
# }

# ################################################################################
# # module "activity" {
# #   source = "../../modules/docker"

# #   solution_stack_name = var.solution_stack_name

# #   region          = var.region
# #   dns_zone_id     = data.terraform_remote_state.dns.outputs.zone_id
# #   dns_subdomain   = "activity.${data.terraform_remote_state.dns.outputs.zone_name}"
# #   instance_type   = var.instance_type
# #   name            = "${data.terraform_remote_state.apps.outputs.activity_app_name}-${var.environment}-${terraform.workspace}"
# #   app_name        = data.terraform_remote_state.apps.outputs.activity_app_name
# #   key_name        = "${var.name}-${var.environment}-${terraform.workspace}"
# #   vpc_id          = module.vpc.vpc_id
# #   private_subnets = join(",", sort(local.private_ecs_subnet_ids))
# #   public_subnets  = join(",", sort(local.public_subnet_ids))
# #   scheme          = "public"
# #   elb_inbound = flatten([
# #     var.trusted_ip_range,
# #     var.cidr,
# #     local.nat_ips,
# #     local.bastion_ip,
# #   ])
# #   InstanceProfileName = data.terraform_remote_state.apps.outputs.aws_iam_instance_profile-beanstalk_ec2
# #   ServiceRoleARN      = data.terraform_remote_state.apps.outputs.aws_iam_role-beanstalk_service
# #   minsize             = var.minsize
# #   maxsize             = var.maxsize

# #   tags = {
# #     Environment = var.environment
# #     Workspace   = terraform.workspace
# #   }
# #   bastion_ssh_sg   = aws_security_group.bastion.id
# #   elb-logs-enabled = "false"
# #   elb-logs-bucket  = module.beanstalk-elb-s3.bucket_name
# #   elb-logs-prefix  = data.terraform_remote_state.apps.outputs.activity_app_name
# #   settings = [
# #     {
# #       namespace = "aws:elasticbeanstalk:application:environment"
# #       name      = "activity.db.aws.secret"
# #       value     = aws_secretsmanager_secret.activity.name
# #       resource  = ""
# #     },
# #     {
# #       namespace = "aws:elasticbeanstalk:application:environment"
# #       name      = "configServer_url"
# #       value     = "http://${module.config.hostname}/config"
# #       resource  = ""
# #     },
# #     {
# #       namespace = "aws:elasticbeanstalk:application:environment"
# #       name      = "ENABLE_XRAY"
# #       value     = "false"
# #       resource  = ""
# #     },
# #     {
# #       namespace = "aws:elasticbeanstalk:application:environment"
# #       name      = "ssl_check_enabled"
# #       value     = "false"
# #       resource  = ""
# #     },
# #     {
# #       namespace = "aws:elasticbeanstalk:trafficsplitting"
# #       name      = "EvaluationTime"
# #       value     = "5"
# #       resource  = ""
# #     },
# #     {
# #       namespace = "aws:elasticbeanstalk:trafficsplitting"
# #       name      = "NewVersionPercent"
# #       value     = "10"
# #       resource  = ""
# #     },
# #     {
# #       namespace = "aws:elasticbeanstalk:application:environment"
# #       name      = "gatewayServer_url"
# #       value     = "https://${module.api.hostname}/"
# #       resource  = ""
# #     }
# #   ]
# #   healthcheck_url              = "/actuator/health"
# #   http_listener_enabled        = false
# #   loadbalancer_certificate_arn = module.acm-activity.arn
# #   loadbalancer_ssl_policy      = "ELBSecurityPolicy-FS-1-2-Res-2019-08"
# #   env                          = var.environment
# #   application_log_level        = var.activity_log_level

# #   deployment_policy = "TrafficSplitting"

# #   enable_spot_instances                      = true
# #   spot_fleet_on_demand_base                  = 1
# #   spot_fleet_on_demand_above_base_percentage = 0
# # }

# # # We have to use "activity.${data.terraform_remote_state.dns.outputs.zone_name}" instead of module.activity.hostname due to circular dependencies.
# # module "acm-activity" {
# #   source = "git::https://github.com/teamclairvoyant/terraform-aws-acm-request-certificate.git?ref=tags/0.11.0-v1"

# #   domain_name = "activity.${data.terraform_remote_state.dns.outputs.zone_name}"
# #   #domain_name                       = module.activity.hostname
# #   zone_name                         = data.terraform_remote_state.dns.outputs.zone_name
# #   process_domain_validation_options = true
# #   ttl                               = "300"
# #   wait_for_certificate_issued       = true
# #   tags                              = module.label.tags
# # }

# ################################################################################
# # module "alb_alarms-activity" {
# #   source  = "cloudposse/alb-target-group-cloudwatch-sns-alarms/aws"
# #   version = "0.15.0"

# #   namespace               = "activity"
# #   stage                   = module.label-alarms.environment
# #   name                    = module.label-alarms.name
# #   tags                    = module.label-alarms.tags
# #   alb_arn_suffix          = data.aws_lb.activity.arn_suffix
# #   target_group_arn_suffix = data.aws_lb_target_group.activity.arn_suffix
# #   #notify_arns             = [module.sns.sns_topic.arn]
# #   alarm_actions              = [module.sns.sns_topic.arn]
# #   ok_actions                 = [module.sns.sns_topic.arn]
# #   treat_missing_data         = "notBreaching"
# #   evaluation_periods         = 2
# #   period                     = 60
# #   target_4xx_count_threshold = -1
# # }

# # data "aws_lb" "activity" {
# #   arn = module.api.load_balancers[0]
# # }

# # data "aws_lb_listener" "activity" {
# #   load_balancer_arn = data.aws_lb.activity.arn
# #   port              = 443
# # }

# # data "aws_lb_target_group" "activity" {
# #   arn = data.aws_lb_listener.activity.default_action[0].target_group_arn
# # }

# ################################################################################
# # module "eb_alarms-activity" {
# #   source = "../../modules/cloudwatch"

# #   namespace        = "activity"
# #   context          = module.label-alarms.context
# #   environment_name = "${data.terraform_remote_state.apps.outputs.activity_app_name}-${module.label-alarms.environment}-${module.label-alarms.name}"
# #   alarm_actions    = [module.sns.sns_topic.arn]
# #   ok_actions       = [module.sns.sns_topic.arn]
# # }

# ################################################################################
# # resource "aws_security_group" "activity_lambda_sg" {
# #   name        = "attendance-lambda-${var.environment}-${terraform.workspace}"
# #   description = "Security group for Attendance Lambdas"
# #   vpc_id      = module.vpc.vpc_id

# #   egress {
# #     from_port   = 0
# #     to_port     = 0
# #     protocol    = "-1"
# #     cidr_blocks = ["0.0.0.0/0"]
# #   }

# #   tags = {
# #     Environment = var.environment
# #     Workspace   = terraform.workspace
# #   }
# # }

# # # module "attendance-default-layer" {
# # #   source  = "terraform-aws-modules/lambda/aws"
# # #   version = "1.44.0"

# # #   create_layer                      = true
# # #   layer_name                        = "layer-attendance-${var.environment}-${terraform.workspace}"
# # #   vpc_subnet_ids                    = local.private_db_subnet_ids
# # #   compatible_runtimes               = ["python3.8"]
# # #   create_package                    = false
# # #   cloudwatch_logs_retention_in_days = 180
# # #   local_existing_package            = "../../modules/activity-lambdas/layers/activity-default-layer.zip"
# # #   tags = {
# # #     Environment = var.environment
# # #     Workspace   = terraform.workspace
# # #   }
# # # }

# # module "user-activity-lambda" {
# #   source  = "terraform-aws-modules/lambda/aws"
# #   version = "1.44.0"

# #   create_function                   = true
# #   vpc_subnet_ids                    = local.private_db_subnet_ids
# #   vpc_security_group_ids            = [aws_security_group.activity_lambda_sg.id]
# #   attach_network_policy             = true
# #   attach_policy_json                = true
# #   policy_json                       = data.aws_iam_policy_document.user-activity.json
# #   attach_policies                   = true
# #   cloudwatch_logs_retention_in_days = 180
# #   policies = [
# #     "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
# #     "arn:aws:iam::aws:policy/CloudWatchLambdaInsightsExecutionRolePolicy",
# #   ]
# #   number_of_policies = 2
# #   function_name      = "user-activity-${var.environment}-${terraform.workspace}"
# #   layers = [
# #     module.attendance-default-layer.this_lambda_layer_arn,
# #     local.lambdainsights_arn[data.aws_region.current.name],
# #   ]
# #   description            = "User Activity Lambda function"
# #   handler                = "lambda_function.lambda_handler"
# #   runtime                = "python3.8"
# #   publish                = true
# #   create_package         = false
# #   timeout                = 120
# #   memory_size            = 256
# #   maximum_retry_attempts = 0
# #   s3_existing_package = {
# #     bucket     = "gce-nextgenlms-attendance-deployment"
# #     key        = "releases/user-activity-lambda/${var.environment}/user-activity-lambda.zip"
# #     version_id = null
# #   }
# #   environment_variables = {
# #     "DEFAULT_START_DATE"       = var.lambda_default_date
# #     "DEFAULT_TIMEZONE"         = "MST"
# #     "TENANT_ID"                = var.default_tenant_id
# #     "CLASSROOM_DB_AWS_SECRET"  = module.secretsmanager-rds-user-classroom.secretsmanager_secret_name
# #     "FORUM_DB_AWS_SECRET"      = module.secretsmanager-rds-user-forum.secretsmanager_secret_name
# #     "CONFIG_DB_AWS_SECRET"     = module.secretsmanager-rds-user-config.secretsmanager_secret_name
# #     "ATTENDANCE_DB_AWS_SECRET" = aws_secretsmanager_secret.activity.name
# #     "ACTIVITY_SPAN_OFFSET"     = 600
# #   }
# #   tags = {
# #     Environment = var.environment
# #     Workspace   = terraform.workspace
# #   }
# # }

# # resource "aws_lambda_alias" "user-activity-lambda-alias" {
# #   name             = "user-activity-lambda-${var.environment}-alias"
# #   description      = "User Activity Lambda Alias"
# #   function_name    = module.user-activity-lambda.this_lambda_function_arn
# #   function_version = "$LATEST"
# # }

# # module "user-activity-lambda-trigger" {
# #   source  = "infrablocks/lambda-cloudwatch-events-trigger/aws"
# #   version = "0.3.0"

# #   region                     = var.region
# #   component                  = "${module.user-activity-lambda.this_lambda_function_name}-trigger"
# #   deployment_identifier      = var.environment
# #   lambda_arn                 = module.user-activity-lambda.this_lambda_function_arn
# #   lambda_function_name       = module.user-activity-lambda.this_lambda_function_name
# #   lambda_schedule_expression = "cron(0/5 * * * ? *))"
# # }

# # module "user-attendance-lambda" {
# #   source  = "terraform-aws-modules/lambda/aws"
# #   version = "1.44.0"

# #   create_function                   = true
# #   vpc_subnet_ids                    = local.private_db_subnet_ids
# #   vpc_security_group_ids            = [aws_security_group.activity_lambda_sg.id]
# #   attach_network_policy             = true
# #   attach_policy_json                = true
# #   policy_json                       = data.aws_iam_policy_document.user-attendance.json
# #   attach_policies                   = true
# #   cloudwatch_logs_retention_in_days = 180
# #   policies = [
# #     "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
# #     "arn:aws:iam::aws:policy/CloudWatchLambdaInsightsExecutionRolePolicy",
# #   ]
# #   number_of_policies = 2
# #   function_name      = "user-attendance-${var.environment}-${terraform.workspace}"
# #   layers = [
# #     module.attendance-default-layer.this_lambda_layer_arn,
# #     local.lambdainsights_arn[data.aws_region.current.name],
# #   ]
# #   description            = "User Attendance Lambda function"
# #   handler                = "lambda_function.lambda_handler"
# #   runtime                = "python3.8"
# #   publish                = true
# #   create_package         = false
# #   timeout                = 180
# #   memory_size            = 256
# #   maximum_retry_attempts = 0
# #   s3_existing_package = {
# #     bucket     = "gce-nextgenlms-attendance-deployment"
# #     key        = "releases/user-attendance-lambda/${var.environment}/user-attendance-lambda.zip"
# #     version_id = null
# #   }
# #   environment_variables = {
# #     "DEFAULT_START_DATE"       = var.lambda_default_date
# #     "DEFAULT_TIMEZONE"         = "MST"
# #     "TENANT_ID"                = var.default_tenant_id
# #     "CONFIG_DB_AWS_SECRET"     = module.secretsmanager-rds-user-config.secretsmanager_secret_name
# #     "ATTENDANCE_DB_AWS_SECRET" = aws_secretsmanager_secret.activity.name
# #     "BATCH_FILE_TEMP_PATH"     = "/tmp/tempfiles"
# #     "S3_BUCKET"                = module.attendance_batches_s3_bucket.bucket_id
# #   }
# #   tags = {
# #     Environment = var.environment
# #     Workspace   = terraform.workspace
# #   }
# # }

# # resource "aws_lambda_alias" "user-attendance-lambda-alias" {
# #   name             = "user-attendance-lambda-${var.environment}-${terraform.workspace}-alias"
# #   description      = "User Attendance Lambda Alias"
# #   function_name    = module.user-attendance-lambda.this_lambda_function_arn
# #   function_version = "$LATEST"
# # }

# # module "user-attendance-lambda-trigger" {
# #   source  = "infrablocks/lambda-cloudwatch-events-trigger/aws"
# #   version = "0.3.0"

# #   region                     = var.region
# #   component                  = "${module.user-attendance-lambda.this_lambda_function_name}-trigger"
# #   deployment_identifier      = var.environment
# #   lambda_arn                 = module.user-attendance-lambda.this_lambda_function_arn
# #   lambda_function_name       = module.user-attendance-lambda.this_lambda_function_name
# #   lambda_schedule_expression = "cron(20 * ? * * *)"
# # }

# # module "user-class-lambda" {
# #   source  = "terraform-aws-modules/lambda/aws"
# #   version = "1.44.0"

# #   create_function                   = true
# #   vpc_subnet_ids                    = local.private_db_subnet_ids
# #   vpc_security_group_ids            = [aws_security_group.activity_lambda_sg.id]
# #   attach_network_policy             = true
# #   attach_policy_json                = true
# #   policy_json                       = data.aws_iam_policy_document.user-class.json
# #   attach_policies                   = true
# #   cloudwatch_logs_retention_in_days = 180
# #   policies = [
# #     "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
# #     "arn:aws:iam::aws:policy/CloudWatchLambdaInsightsExecutionRolePolicy",
# #   ]
# #   number_of_policies = 2
# #   function_name      = "user-class-${var.environment}-${terraform.workspace}"
# #   layers = [
# #     module.attendance-default-layer.this_lambda_layer_arn,
# #     local.lambdainsights_arn[data.aws_region.current.name],
# #   ]
# #   description            = "User Attendance Lambda function"
# #   handler                = "lambda_function.lambda_handler"
# #   runtime                = "python3.8"
# #   publish                = true
# #   create_package         = false
# #   timeout                = 900
# #   memory_size            = 128
# #   maximum_retry_attempts = 0
# #   s3_existing_package = {
# #     bucket     = "gce-nextgenlms-attendance-deployment"
# #     key        = "releases/user-class-lambda/${var.environment}/user-class-lambda.zip"
# #     version_id = null
# #   }
# #   environment_variables = {
# #     "DEFAULT_START_DATE"       = var.lambda_default_date
# #     "DEFAULT_TIMEZONE"         = "MST"
# #     "TENANT_ID"                = var.default_tenant_id
# #     "CLASSROOM_DB_AWS_SECRET"  = module.secretsmanager-rds-user-classroom.secretsmanager_secret_name
# #     "CONFIG_DB_AWS_SECRET"     = module.secretsmanager-rds-user-config.secretsmanager_secret_name
# #     "ATTENDANCE_DB_AWS_SECRET" = aws_secretsmanager_secret.activity.name
# #   }
# #   tags = {
# #     Environment = var.environment
# #     Workspace   = terraform.workspace
# #   }
# # }

# # resource "aws_lambda_alias" "user-class-lambda-alias" {
# #   name             = "user-class-lambda-${var.environment}-alias"
# #   description      = "User Class Lambda Alias"
# #   function_name    = module.user-class-lambda.this_lambda_function_arn
# #   function_version = "$LATEST"
# # }

# # module "user-class-lambda-trigger" {
# #   source  = "infrablocks/lambda-cloudwatch-events-trigger/aws"
# #   version = "0.3.0"

# #   region                     = var.region
# #   component                  = "${module.user-class-lambda.this_lambda_function_name}-trigger"
# #   deployment_identifier      = var.environment
# #   lambda_arn                 = module.user-class-lambda.this_lambda_function_arn
# #   lambda_function_name       = module.user-class-lambda.this_lambda_function_name
# #   lambda_schedule_expression = "cron(0/30 * * * ? *))"
# # }

# ################################################################################
# data "aws_iam_policy_document" "user-activity" {
#   statement {
#     sid    = "ReadSecrets"
#     effect = "Allow"
#     actions = [
#       "secretsmanager:GetSecretValue",
#     ]
#     # resources = [
#     #   module.secretsmanager-rds-user-classroom.secretsmanager_secret_arn,
#     #   module.secretsmanager-rds-user-config.secretsmanager_secret_arn,
#     #   module.secretsmanager-rds-user-forum.secretsmanager_secret_arn,
#     #   aws_secretsmanager_secret.activity.arn,
#     # ]
#   }
#   statement {
#     sid    = "ReadKMSKey"
#     effect = "Allow"
#     actions = [
#       "kms:Decrypt",
#       "kms:DescribeKey",
#       "kms:GenerateDataKey",
#     ]
#     # resources = [
#     #   module.secretsmanager-rds-user-classroom.kms_key_arn,
#     #   module.secretsmanager-rds-user-config.kms_key_arn,
#     #   module.secretsmanager-rds-user-forum.kms_key_arn,
#     # ]
#   }
# }

# data "aws_iam_policy_document" "user-attendance" {
#   statement {
#     sid    = "ReadSecrets"
#     effect = "Allow"
#     actions = [
#       "secretsmanager:GetSecretValue",
#     ]
#     # resources = [
#     #   module.secretsmanager-rds-user-config.secretsmanager_secret_arn,
#     #   aws_secretsmanager_secret.activity.arn,
#     # ]
#   }
#   statement {
#     sid    = "ReadKMSKey"
#     effect = "Allow"
#     actions = [
#       "kms:Decrypt",
#       "kms:DescribeKey",
#       "kms:GenerateDataKey",
#     ]
#     # resources = [
#     #   module.secretsmanager-rds-user-config.kms_key_arn,
#     # ]
#   }
#   statement {
#     sid    = "WriteToS3Bucket"
#     effect = "Allow"
#     actions = [
#       "s3:PutObject",
#     ]
#     # resources = ["arn:aws:s3:::${module.attendance_batches_s3_bucket.bucket_id}/*"]
#   }
# }

# data "aws_iam_policy_document" "user-class" {
#   statement {
#     sid    = "ReadSecrets"
#     effect = "Allow"
#     actions = [
#       "secretsmanager:GetSecretValue",
#     ]
#     # resources = [
#     #   module.secretsmanager-rds-user-classroom.secretsmanager_secret_arn,
#     #   module.secretsmanager-rds-user-config.secretsmanager_secret_arn,
#     #   aws_secretsmanager_secret.activity.arn,
#     # ]
#   }
#   statement {
#     sid    = "ReadKMSKey"
#     effect = "Allow"
#     actions = [
#       "kms:Decrypt",
#       "kms:DescribeKey",
#       "kms:GenerateDataKey",
#     ]
#     # resources = [
#     #   module.secretsmanager-rds-user-classroom.kms_key_arn,
#     #   module.secretsmanager-rds-user-config.kms_key_arn,
#     # ]
#   }
# }

# ################################################################################
# data "aws_iam_policy_document" "gcu_proxy" {
#   statement {
#     sid       = "GcuProxyReadBucket"
#     effect    = "Allow"
#     actions   = ["s3:ListBucket"]
#     resources = ["arn:aws:s3:::${module.attendance_batches_s3_bucket.bucket_id}"]
#   }
#   statement {
#     sid       = "GcuProxyReadObjects"
#     effect    = "Allow"
#     actions   = ["s3:GetObject"]
#     resources = ["arn:aws:s3:::${module.attendance_batches_s3_bucket.bucket_id}/*"]
#   }
# }

# resource "aws_iam_policy" "gcu_proxy-ReadS3Bucket" {
#   name        = "AttendanceBucketReadAccess${module.attendance_batches_s3_bucket.bucket_id}"
#   description = "Allows ${module.attendance_batches_s3_bucket.bucket_id} S3 bucket read access"
#   policy      = data.aws_iam_policy_document.gcu_proxy.json
# }

# resource "aws_iam_user" "gcu_proxy" {
#   name = "gcu_proxy-${var.environment}"
# }

# resource "aws_iam_user_policy_attachment" "gcu_proxy" {
#   policy_arn = aws_iam_policy.gcu_proxy-ReadS3Bucket.arn
#   user       = aws_iam_user.gcu_proxy.name
# }

# # resource "aws_cloudwatch_metric_alarm" "eb-activity-instance" {
# #   alarm_name          = "beanstalk-${var.environment}-activity-nodata"
# #   alarm_description   = "No data received from the instance for over a period of 4 mins"
# #   metric_name         = "InstancesNoData"
# #   namespace           = "AWS/ElasticBeanstalk"
# #   comparison_operator = "LessThanThreshold"
# #   evaluation_periods  = "2"
# #   period              = "120"
# #   statistic           = "Average"
# #   alarm_actions       = [module.sns.sns_topic.arn]
# #   ok_actions          = [module.sns.sns_topic.arn]
# #   dimensions = {
# #     EnvironmentName = "${data.terraform_remote_state.apps.outputs.activity_app_name}-${var.environment}-${terraform.workspace}"
# #   }
# # }

# ################################################################################

# //OUTPUTS
# # output "arn-attendance-layer-default" {
# #   value = module.attendance-default-layer.this_lambda_layer_arn
# # }

# # output "endpoint_url-activity" {
# #   value = module.activity.hostname
# # }
