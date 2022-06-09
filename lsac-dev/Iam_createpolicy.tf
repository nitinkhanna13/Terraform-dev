#####################  ECR FULL ACCESS #############################
data "aws_iam_policy_document" "ECR_FULL_ACCESS" {
  statement {
    sid       = "FullAccess"
    effect    = "Allow"
    resources = ["arn:aws:ecr:us-east-1:545597221468:repository/${module.test-ecr.repository_name}"]

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
      "ecr:GetLifecyclePolicy",
      "ecr:GetLifecyclePolicyPreview",
      "ecr:ListTagsForResource",
      "ecr:DescribeImageScanFindings",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage"
    ]
  }
}


resource "aws_iam_policy" "ECR_FULL_ACCESS" {
  name        = "ECRFULLACCESS"
  description = "ECR policy attach to user"
  policy      = data.aws_iam_policy_document.ECR_FULL_ACCESS.json
}

########################## ECR READ ACCESS ###############################

data "aws_iam_policy_document" "ECR_READ_ACCESS" {
  statement {
    sid       = "READACCESS"
    effect    = "Allow"
    resources = ["arn:aws:ecr:us-east-1:545597221468:repository/cdh/test-ecr"]

    actions = [
      "ecr:DescribeImageScanFindings",
      "ecr:GetLifecyclePolicyPreview",
      "ecr:GetDownloadUrlForLayer",
      "ecr:DescribeImageReplicationStatus",
      "ecr:ListTagsForResource",
      "ecr:ListImages",
      "ecr:BatchGetRepositoryScanningConfiguration",
      "ecr:BatchGetImage",
      "ecr:DescribeImages",
      "ecr:DescribeRepositories",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetRepositoryPolicy",
      "ecr:GetLifecyclePolicy"
    ]
  }
}

resource "aws_iam_policy" "ECR_READ_ACCESS" {
  name        = "ECR_READ_ACCESS"
  description = "ECR  READ policy attach to user"
  policy      = data.aws_iam_policy_document.ECR_READ_ACCESS.json
}

###################################################################################