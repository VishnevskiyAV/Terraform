provider "aws" {
  region = "eu-central-1"
}

provider "aws" {
  region = "us-west-2"
  alias  = "dev"

  assume_role {
    role_arn = "arn:aws:iam::XXXXXXXXX:role/TerraformRole"
  }
}

provider "aws" {
  region = "ca-central-1"
  alias  = "prod"

  assume_role {
    role_arn = "arn:aws:iam::XXXXXXXXX:role/TerraformRole"
  }
}

#_____________________________________________________________________

module "servers" {
  source = "../lesson42/module"
  instance_type = "t2.micro"
  providers = {
    aws.root = aws
    aws.prod = aws.prod
    aws.dev = aws.dev
   }
}
