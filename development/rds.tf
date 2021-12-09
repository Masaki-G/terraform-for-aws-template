#DB
module "rds" {
  source         = "./module/rds"
  private_subnet = [module.subnet.private_subnet_1, module.subnet.private_subnet_2]
<<<<<<< HEAD
  rds_name       = "dev-example-rds"
  vpc_id         = module.subnet.vpc
  password       = "xxxxxxx"
  database_name  = "xxxxxxx"
=======
  rds_name       = "dev-mitsuibau-rds"
  vpc_id         = module.subnet.vpc
  password       = "mzukewBaHc8y"
  database_name  = "mitsuibau"
>>>>>>> c36c93c9edeb47bb58e89c43f4df4fc5f9b1741b

}

#環境変数管理
module "ssm" {
  source      = "./module/ssm"
  db_name     = module.rds.db_name
  db_username = module.rds.db_username
  db_endpoint = module.rds.db_endpoint
  db_port     = module.rds.db_port
  db_password = module.rds.db_password
}