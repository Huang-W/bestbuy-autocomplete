resource "aws_db_instance" "bestbuy-postgres" {
  allocated_storage      = 10
  engine                 = "postgres"
  engine_version         = "13.4"
  instance_class         = "db.t3.micro"
  db_subnet_group_name   = aws_db_subnet_group.default.id
  vpc_security_group_ids = [data.terraform_remote_state.infrastructure.outputs.postgres_security_group_id]
  identifier             = "bestbuy-postgres"
  name                   = "bestbuy"
  username               = data.aws_ssm_parameter.bestbuy-postgres-user.value
  password               = data.aws_ssm_parameter.bestbuy-postgres-password.value
  parameter_group_name   = aws_db_parameter_group.postgres.id
  skip_final_snapshot    = true
}

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = data.terraform_remote_state.infrastructure.outputs.pv1_subnet_ids

  tags = {}
}

resource "aws_db_parameter_group" "postgres" {
  name   = "postgres-pg"
  family = "postgres13"

  parameter {
    apply_method = "pending-reboot"
    name         = "client_encoding"
    value        = "UTF8"
  }
}

data "aws_ssm_parameter" "bestbuy-postgres-user" {
  name = "/bestbuy-postgres/master-user/name"
}

data "aws_ssm_parameter" "bestbuy-postgres-password" {
  name = "/bestbuy-postgres/master-user/password"
}
