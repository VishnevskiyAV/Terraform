#Auto fill parameters for 

regions       = "us-east-1"
instance_type = "t2.micro"
key_name      = "East"
allow_ports   = ["8080"]

common_tags = {
  Owner       = "Aleksandr V."
  Project     = "tfvars"
  Environment = "Prod"
}

#terraform apply -var-file="dev.auto.tfvars"