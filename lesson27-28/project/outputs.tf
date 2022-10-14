output "dev_vpc_id" {
  value = module.vpc-dev.vpc_cidr
}

output "dev_private_subnet_id" {
  value = module.vpc-dev.private_subnet_ids
}

output "dev_public_subnet_id" {
  value = module.vpc-dev.public_subnet_ids
}
