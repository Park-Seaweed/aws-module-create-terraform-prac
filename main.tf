provider "aws" {
  region = "ap-northeast-2"
}

module "network" {
  source = "./modules/network"
  public_subnet_cidr_list = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]
  private_subnet_cidr_list = [
    "10.0.3.0/24",
    "10.0.4.0/24"
  ]
  availability_zone_list = [
    "ap-northeast-2a",
    "ap-northeast-2c"
  ]
}

module "ec2" {
  source        = "./modules/ec2"
  server_port   = 8080
  image_id      = "ami-0cb1d752d27600adb"
  instance_type = "t2.micro"
  public_subnet = module.network.public_subnet_id
  vpc_id        = module.network.vpc_id
}
