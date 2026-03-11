provider "aws" {
  region = var.region
  profile = "admin"
}


module "sg_module" {
    source = "./modules/sg_module"
    public_subnet1_cidr = "10.0.2.0/24"
    public_subnet2_cidr = "10.0.3.0/24"
  
}
module "ec2_modul1" {
    sg_id = "${module.sg_module.sg_id_output}"
    varsub = "${module.sg_module.subnet_id_output}"
    keyn = "febcourse"
    source = "./modules/ec2_module"
  
}

module "acm" {
  source = "./modules/acm"

  count       = var.use_acm ? 1 : 0
  domain_name = var.domain_name
}

module "alb" {
  source = "./modules/loadbalancer"

  vpc_id            = module.sg_module.vpc_id_output
  public_subnets   = [module.sg_module.subnet1_id_output, module.sg_module.subnet2_id_output]
  security_group_id = module.sg_module.sg_id_output
  instance_id       = module.ec2_modul1.instance_id
  certificate_arn = var.use_acm ? module.acm[0].certificate_arn : null
}



output "load_balancer_dns" {
  value = module.alb.alb_dns
}

# optional output only when ACM is used
output "certificate_arn" {
  value       = var.use_acm ? module.acm[0].certificate_arn : null
  description = "ARN of the generated ACM certificate (if enabled)"
}

output "ec2_public_ip" {
  value =  module.ec2_modul1.ec2_public_ip
}
