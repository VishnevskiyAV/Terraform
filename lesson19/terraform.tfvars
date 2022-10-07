#Auto fill parameters for 

regions       = "us-west-1"
instance_type = "t3.micro"
key_name      = "West"
allow_ports   = ["8080"]

common_tags = {
  Owner       = "Aleksandr V."
  Project     = "tfvars"
  Environment = "test"
}

# terraform apply 