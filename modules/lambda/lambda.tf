#read in pythons cripts for app and delete functions
data "archive_file" "zip" {
    type        = "zip"
    source_file = "user_uploads.py"
    output_path = "user_uploads.zip" 

}
data "archive_file" "zip_delete" {
    type        = "zip"
    source_file = "delete_function.py"
    output_path = "delete_function.zip" 

}

#import pymysql lambda layer
resource "aws_lambda_layer_version" "lambda_layer" {
  filename   = "../Project-1/python.zip"
  layer_name = "pymysql"
  compatible_runtimes = [var.lambda_runtime]
}


#create lambda for app 
resource "aws_lambda_function" "app_lambda" {
  filename      = "${data.archive_file.zip.output_path}"
  function_name = "user_uploads"
  role          = aws_iam_role.iam_for_app_lambda.arn
  handler       = "user_uploads.lambda_handler"
  timeout       =  300
  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = "${data.archive_file.zip.output_base64sha256}" 
  runtime = var.lambda_runtime
  layers = [aws_lambda_layer_version.lambda_layer.arn]
  vpc_config {
    subnet_ids         = [var.privsubnet1_id, var.privsubnet2_id ]
    security_group_ids = [var.sg_id_lambda]
  }

  # environment {
  #   variables = {
  #     name = "bar"
  #   }
  # }
}


#create lambda function to delete old records from table

resource "aws_lambda_function" "delete_lambda" {
  filename      = "${data.archive_file.zip_delete.output_path}"
  function_name = "delete_function"
  role          = aws_iam_role.iam_for_delete_lambda.arn
  handler       = "delete_function.lambda_handler"
  timeout       =  300
  source_code_hash = "${data.archive_file.zip_delete.output_base64sha256}" 
  runtime = var.lambda_runtime
  layers = [aws_lambda_layer_version.lambda_layer.arn]
  vpc_config {
    subnet_ids         = [var.privsubnet1_id, var.privsubnet2_id ]
    security_group_ids = [var.sg_id_lambda]
  }

  # environment {
  #   variables = {
  #     foo = "bar"
  #   }
  # }
}


#daily cw event trigger for delete function
resource "aws_cloudwatch_event_rule" "every_day" {
    name = "every-day"
    description = "Fires every day"
    schedule_expression = "rate(1 day)"
}

resource "aws_cloudwatch_event_target" "delete_every_day" {
    rule = aws_cloudwatch_event_rule.every_day.name
    target_id = "delete_lambda" 
    arn = aws_lambda_function.delete_lambda.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_delete" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.delete_lambda.function_name
    principal = "events.amazonaws.com"
    source_arn = aws_cloudwatch_event_rule.every_day.arn
}

#cloudwatch log groups
resource "aws_cloudwatch_log_group" "delete_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.delete_lambda.function_name}"
  retention_in_days = var.log_retention
  lifecycle {
    prevent_destroy = false
  }
}
resource "aws_cloudwatch_log_group" "app_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.app_lambda.function_name}"
  retention_in_days = var.log_retention
  lifecycle {
    prevent_destroy = false
  }
}
