output "db_endpoint" {
    value = aws_db_instance.default.endpoint
    sensitive=true
}

output "secret_kms_keyId"{
  value=aws_kms_key.secrets_kms_key.key_id
}

output "secret_kms_keyArn"{
  value=aws_kms_key.secrets_kms_key.arn
}
