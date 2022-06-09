

data "aws_iam_policy_document" "attendance_batches_s3_bucket" {
  statement {
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${module.attendance_batches_s3_bucket.bucket_id}"]
    effect = "Allow"
  }
  statement {
    actions   = ["s3:PutObject",
                 "s3:GetObject",
	               "s3:DeleteObject"]
    resources = ["arn:aws:s3:::${module.attendance_batches_s3_bucket.bucket_id}"]
    effect = "Allow"
  }
}

resource "aws_iam_policy" "attendance_batches_s3_bucket" {
  name        = "attendance_batches_s3_bucket"
  description = "S3 access buckets"
  policy      = data.aws_iam_policy_document.attendance_batches_s3_bucket.json
}

resource "aws_iam_user_policy_attachment"  "cdh-stest" {
    for_each   = toset(["arn:aws:iam::915076882459:policy/attendance_batches_s3_bucket"])
    user       = data.terraform_remote_state.globals.outputs.lsac-user
    policy_arn = each.value
}



###########################################################################