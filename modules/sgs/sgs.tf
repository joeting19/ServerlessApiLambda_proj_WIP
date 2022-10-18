

resource "aws_security_group" "sg_lambda" {
  name        = "Lambda sg"
  vpc_id      = var.vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
    tags = {
    Name = "Lambda sg"
  }
}

resource "aws_security_group" "DB-SG" {
  name        = "DB sg"
  description = "Allow 5432"
  vpc_id      = var.vpc_id
  ingress {
    description      = "DB SG"
    from_port        = var.db_port
    to_port          = var.db_port
    protocol         = "tcp"
    security_groups  = [aws_security_group.sg_lambda.id]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "DB sg"
  }
}