
variable "ami_id" {
  default = "ami-048d25c1bda4feda7" # Ubuntu 18.04.3 Bionic, custom
}

# AWS provider
provider "aws" {
  profile    = "default"
  region     = "eu-central-1"
}

resource "random_id" "server" {
  keepers = {
    # Generate a new id each time we switch to a new AMI id
    ami_id = "${var.ami_id}"
  }
  byte_length = 8
}

resource "random_password" "password" {
  length = 16
  special = true
  override_special = "_%@"
}

resource "random_shuffle" "separation_zone" {
  input = ["europe", "asia", "us", "australia", "antarctica"]
  result_count = 1 # return only ONE zone
}

resource "random_integer" "subzone" {
  min     = 1
  max     = 3
}

resource "aws_instance" "randomexample" {
  # Read the AMI id "through" the random_id resource to ensure that
  # both will change together.
  ami = "${random_id.server.keepers.ami_id}"

  instance_type = "t2.micro"

  tags = {
    "name" = "randomexample-${random_id.server.hex}"
    "future_password" = random_password.password.result
    "zone" = "${element(random_shuffle.separation_zone.result,0)}"
    "subzone" = "${random_integer.subzone.result}"
  }
}

output "server_tags" {
  value = "${aws_instance.randomexample.tags}"
}