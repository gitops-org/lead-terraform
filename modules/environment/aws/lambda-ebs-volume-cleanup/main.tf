# Zip up the lambda function code
data "archive_file" "lambda_zip" {
    type        = "zip"
    source_dir  = "python"
    output_path = "lambda.zip"
}

# Create the lambda role
resource "aws_iam_role" "lambda_role" {
  name = "${var.region}_lambda_ebs_volume_cleanup_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Sid": ""
    }
  ]
}
EOF
}

# Create our policy that allows logging and volume management
# may need ec2:DescribeVolumeAttributes
resource "aws_iam_policy" "lambda_policy" {
  name        = "${var.region}_lambda_ebs_volume_cleanup"
  path        = "/"
  description = "IAM policy for ebs volume cleanup lambda to create logs, and access ec2 resources"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    },
    {
        "Action": [
            "ec2:DeleteVolume",
            "ec2:DescribeVolumes",
        ],
        "Resource": "arn:aws:ec2:*:*:*",
        "Effect": "Allow"
    }
  ]
}
EOF
}

# Attach our policy to our role
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

# Create the lambda
resource "aws_lambda_function" "lambda_ebs_volume_cleanup" {
  filename = "lambda.zip"
  source_code_hash = "${data.archive_file.lambda_zip.output_base64sha256}"
  function_name = "lambda-ebs-volume-cleanup"
  role = "${aws_iam_role.lambda_role.arn}"
  description = "AWS Lambda to cleanup available EBS Volumes"
  handler = "ebs_volume_cleanup.handler"
  runtime = "python3.8"
  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs,
    aws_cloudwatch_log_group.example,
  ]
}

# Cleanup after ourselves, deleting the zip
resource "null_resource" "cleanup lambda.zip" {
  provisioner "local-exec" {
    command = "rm lambda.zip"
  }
}