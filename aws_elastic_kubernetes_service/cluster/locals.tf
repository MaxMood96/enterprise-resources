resource "aws_secretsmanager_secret" "connections" {
  name = "codecov-connections"
  tags = var.resource_tags
}

resource "aws_secretsmanager_secret_version" "connections" {
  secret_id = aws_secretsmanager_secret.connections.id
  secret_string = jsonencode({
    minio_access_key = aws_iam_access_key.minio.id
    minio_secret_key = aws_iam_access_key.minio.secret
    minio_bucket     = aws_s3_bucket.minio.id
    postgres_url     = "postgres://${aws_db_instance.postgres.username}:${aws_db_instance.postgres.password}@${aws_db_instance.postgres.endpoint}/${aws_db_instance.postgres.name}"
    redis_url        = "redis://${aws_elasticache_cluster.redis.cache_nodes[0].address}:${aws_elasticache_cluster.redis.cache_nodes[0].port}"
  })
}