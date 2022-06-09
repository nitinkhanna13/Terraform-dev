resource "aws_iam_user_policy_attachment" "testuser" {
    user      = module.testuser.user_name
    policy_arn = aws_iam_policy.ECR_FULL_ACCESS.arn
}

###################################################################

resource "aws_iam_user_policy_attachment" "cdhuser" {
    for_each = toset(["arn:aws:iam::915076882459:policy/ECRFULLACCESS",
               "arn:aws:iam::915076882459:policy/ECR_READ_ACCESS"])
    user      = module.tftest.user_name
    policy_arn = each.value
}


###########################################################################

resource "aws_iam_user_policy_attachment" "lsac-user" {
    for_each = toset(["arn:aws:iam::915076882459:policy/ECRFULLACCESS"])
    user      = module.lsac-user.user_name
    policy_arn = each.value
}

