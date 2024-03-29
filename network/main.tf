provider "aws" {
  #version = "~> 2.28"  
  #region     = var.aws_region
  #access_key = var.aws_key
  #secret_key = var.aws_sec
}

#data "aws_route53_zone" "selected" {
#  name         = var.aws_route53_zone_name
#  #private_zone = false
#}

module "vpc" {
  source = "app.terraform.io/CentenePoC/vpc/aws"
  #aws_region = var.aws_region
  no_of_subnets = var.no_of_subnets
  aws_vpc_cidr_block   = var.aws_vpc_cidr_block
  app_env   = var.app_env
  app_name   = var.app_name  
  app_id   = var.app_id  
  aws_vpc_instance_tenancy = var.aws_vpc_instance_tenancy
}

module "sg" {
  source = "app.terraform.io/CentenePoC/sg/aws"
  #aws_region = var.aws_region
  aws_vpc_id = module.vpc.aws_vpc_id
  app_env   = var.app_env
  app_name   = var.app_name  
  app_id   = var.app_id
  aws_sg_name   = var.aws_sg_name    
}

module "elb" {
  source = "app.terraform.io/CentenePoC/elb/aws"
  #aws_region = var.aws_region
  aws_subnet_ids = module.vpc.aws_subnet_ids 
  aws_security_group_elb_id = module.sg.aws_security_group_elb_id
  lb_ssl_id = "1234"  
  app_env   = var.app_env
  app_name   = var.app_name  
  app_id   = var.app_id    
}

#module "route53" {
#  source = "app.terraform.io/CentenePoC/route53/aws"
#  aws_region = var.aws_region
#  app_env   = var.app_env
#  app_name  = var.app_name  
#  app_id   = var.app_id  
#  aws_route53_zone_id = data.aws_route53_zone.selected.zone_id
#  aws_route53_record_name = var.aws_route53_record_name

#  # Adding to "dulastack." needs to be revied with service owner 
#  #aws_elb_dns_name = var.aws_elb_dns_name == "" ? "dummy-elb.us-east-1.elb.amazonaws.com" : "dualstack.${var.aws_elb_dns_name}"
#  aws_elb_dns_name = module.elb.aws_elb_dns_name #"dualstack.${module.elb.aws_elb_dns_name}"

#  # Passing defalut us-east-1 zone id to avoid apply error, logic needs to change later 
#  #aws_elb_zone_id = var.aws_elb_zone_id == "" ? "Z35SXDOTRQ7X7K" : var.aws_elb_zone_id
#  aws_elb_zone_id = module.elb.aws_elb_zone_id


#  repave_strategy = var.repave_strategy 
#  aws_route53_zone_name = var.aws_route53_zone_name
#  aws_vpc_id = module.vpc.aws_vpc_id
#}

module "ec2key" {
  source = "app.terraform.io/CentenePoC/ec2-key/aws"
  #aws_region = var.aws_region
  app_env   = var.app_env
  app_name   = var.app_name  
  app_id   = var.app_id 
  path_to_public_key = var.path_to_public_key   
}




