locals {
  govcloud_enabled = length(regexall("gov", var.region)) > 0
  partition        = data.aws_partition.current.partition
  dns_suffix       = data.aws_partition.current.dns_suffix
}