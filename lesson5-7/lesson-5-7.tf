provider "aws" {
  region = "eu-central-1"
}

/* For exporting to the environment variables
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export AWS_DEFAULT_REGION=
*/

resource "aws_instance" "my_Amazon_Linux" {
  count         = 0
  ami           = "ami-05ff5eaef6149df49"
  instance_type = "t2.micro"
  tags = {
    name    = "my amazon server"
    owner   = "AV"
    project = "terraform lessons"
  }
}

resource "aws_instance" "my_ubuntu" {
  ami           = "ami-0caef02b518350c8b"
  instance_type = "t3.micro"
  tags = {
    name    = "my amazon server"
    owner   = "AV"
    project = "terraform lessons"
  }
}
