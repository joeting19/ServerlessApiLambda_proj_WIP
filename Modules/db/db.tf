resource "aws_db_subnet_group" "subnetgroup" {
  name       = "subnetgroup"
  subnet_ids = [var.privsubnet3_id, var.privsubnet4_id]
  tags = { Name = "My DB subnet group"}
}

resource "aws_db_instance" "default" {
  allocated_storage    = var.db_storage_min
  max_allocated_storage= var.db_storage_max
  engine               = var.db_engine
  engine_version       = var.db_engine_version
  instance_class       = var.db_instance_class
  vpc_security_group_ids = [var.dbsg_id]
  db_subnet_group_name = aws_db_subnet_group.subnetgroup.name
  db_name               = var.db_name
  username             = var.db_username
  password             = var.db_password
  skip_final_snapshot  = true
  enabled_cloudwatch_logs_exports = ["audit", "general", "slowquery", "error"]
}

resource "aws_cloudwatch_log_group" "db_log_group" {
  name              = "/aws/rds/instance/${aws_db_instance.default.name}"
  retention_in_days = var.log_retention
  lifecycle {
    prevent_destroy = false
  }
}

