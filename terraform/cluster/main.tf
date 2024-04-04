module "networking" {
    source          = "./modules/networking"

    vpc_name        = var.vpc_name
    cluster_name    = var.cluster_name
}

module "rds" {
    source = "./modules/rds"
    
    db-subnet-group-name = "db-subnet-group"
    db_name = "databaseGroupProject"
    subnet_ids = module.networking.public_subnets

    instance_class = "db.t3.micro"
    engine = "postgres"
    engine_version = "15.5"
    vpc_security_group_ids = module.sg.security_group_ids
}

module "sg" {
    source = "./modules/sg"
    vpc_id = module.networking.vpc_id
}

module "eks" {
  source = "./modules/eks"
  cluster_name = var.cluster_name
  vpc_id = module.networking.vpc_id
  private_subnets = module.networking.private_subnets
  security_group_ids = module.sg.security_group_ids
}
