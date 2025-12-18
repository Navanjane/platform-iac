data "aws_iam_policy_document" "terraform_trust" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::147145168434:user/bootstrap-admin"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "terraform" {
  name               = "terraform-execution-role"
  assume_role_policy = data.aws_iam_policy_document.terraform_trust.json

  tags = {
    Purpose = "Terraform provisioning"
  }
}

