#iam permissions policies for functions
resource "aws_iam_policy" "function_logging_policy" {
  name   = "function-logging-policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        Action : [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect : "Allow",
        Resource : "arn:aws:logs:*:*:*"
      }
    ]
  })
}
resource "aws_iam_policy" "decrypt_kms_policy" {
  name   = "kms-decrypt-policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        Action : [
          "kms:Decrypt",
          "kms:Get*"
        ],
        Effect : "Allow",
        Resource : [var.secret_kms_keyArn, var.db_secrets_arn]
    
      }
    ]
  })
}
resource "aws_iam_policy" "get_secret_policy" {
  name   = "get-secret-policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        Action : [
        "secretsmanager:GetSecretValue"
        ],
        Effect : "Allow",
        Resource : var.db_secrets_arn
      }
    ]
  })
}

resource "aws_iam_role" "iam_for_app_lambda" {
  name = "iam_for_app_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


#attach policies to app role
resource "aws_iam_role_policy_attachment" "app_lambda_vpc_role_attachment" {
  role       = aws_iam_role.iam_for_app_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "app_lambda_role_logging" {
  role       = aws_iam_role.iam_for_app_lambda.name
  policy_arn = aws_iam_policy.function_logging_policy.arn
}

resource "aws_iam_role_policy_attachment" "app_lambda_role_decrypt" {
  role       = aws_iam_role.iam_for_app_lambda.name
  policy_arn = aws_iam_policy.decrypt_kms_policy.arn
}

resource "aws_iam_role_policy_attachment" "app_lambda_role_getsecret" {
  role       = aws_iam_role.iam_for_app_lambda.name
  policy_arn = aws_iam_policy.get_secret_policy.arn
}



#iam role for delete function
resource "aws_iam_role" "iam_for_delete_lambda" {
  name = "iam_for_delete_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
#attach policies to delete role
resource "aws_iam_role_policy_attachment" "delete_lambda_vpc_role_attachment" {
  role       = aws_iam_role.iam_for_delete_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "delete_lambda_role_logging" {
  role       = aws_iam_role.iam_for_delete_lambda.name
  policy_arn = aws_iam_policy.function_logging_policy.arn
}

resource "aws_iam_role_policy_attachment" "delete_lambda_role_decrypt" {
  role       = aws_iam_role.iam_for_delete_lambda.name
  policy_arn = aws_iam_policy.decrypt_kms_policy.arn
}

resource "aws_iam_role_policy_attachment" "delete_lambda_role_getsecret" {
  role       = aws_iam_role.iam_for_delete_lambda.name
  policy_arn = aws_iam_policy.get_secret_policy.arn
}




