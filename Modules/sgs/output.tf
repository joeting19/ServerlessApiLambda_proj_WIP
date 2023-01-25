output "sg_id_lambda" {
    value = aws_security_group.sg_lambda.id
}

output "dbsg_id" {
    value=aws_security_group.DB-SG.id 

}
