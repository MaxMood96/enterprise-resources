resource "aws_db_subnet_group" "postgres" {
  name       = "codecov-postgres"
  subnet_ids = module.vpc.private_subnets

  tags = var.resource_tags
}

resource "aws_security_group" "postgres" {
  name_prefix = "codecov-postgres"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"

    cidr_blocks = [
      module.vpc.vpc_cidr_block,
    ]
  }

  tags = var.resource_tags
}

resource "random_string" "postgres-password" {
  length  = "16"
  special = "false"
}

resource "random_string" "identifier-suffix" {
  length  = "3"
  special = "false"
  upper   = "false"
}

resource "aws_db_instance" "postgres" {
  identifier                = "codecov-postgres-${random_string.identifier-suffix.result}"
  engine                    = "postgres"
  engine_version            = "10.6"
  allocated_storage         = "20"
  storage_type              = "gp2"
  instance_class            = var.postgres_instance_class
  db_subnet_group_name      = aws_db_subnet_group.postgres.name
  db_name                   = "codecov"
  username                  = "codecov"
  password                  = random_string.postgres-password.result
  vpc_security_group_ids    = [aws_security_group.postgres.id]
  skip_final_snapshot       = var.postgres_skip_final_snapshot
  final_snapshot_identifier = "codecov-postgres-${random_string.identifier-suffix.result}-final"

  tags = var.resource_tags
}

resource "aws_elasticache_subnet_group" "redis" {
  name       = "codecov-redis"
  subnet_ids = module.vpc.private_subnets
}

resource "aws_security_group" "elasticache" {
  name_prefix = "codecov-elasticache"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 6379
    to_port   = 6379
    protocol  = "tcp"

    cidr_blocks = [
      module.vpc.vpc_cidr_block,
    ]
  }

  tags = var.resource_tags
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id         = "codecov-redis-${random_string.identifier-suffix.result}"
  engine             = "redis"
  node_type          = var.redis_node_type
  num_cache_nodes    = var.redis_num_nodes
  engine_version     = "5.0.3"
  subnet_group_name  = aws_elasticache_subnet_group.redis.name
  security_group_ids = [aws_security_group.elasticache.id]

  tags = var.resource_tags
}
