output "app_lambda_uri" {
    value = aws_lambda_function.app_lambda.invoke_arn 
}
output "app_lambda_name" {
    value = aws_lambda_function.app_lambda.function_name
}


