provider "yandex" {
  zone                     = var.zone
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  service_account_key_file = var.service_account_key_file
  version                  = "~> 0.35"
}

module "vpc" {
  source 		= "./modules/vpc"
}

module "app" {
  source 		= "./modules/app"
  public_key_path 	= var.public_key_path
#  subnet_id		= var.subnet_id
  subnet_id		= module.vpc.app_subnet_id
  app_image_id		= var.app_image_id
  db_ip			= module.db.internal_db_ip_address

}

module "db" {
  source 		= "./modules/db"
  public_key_path 	= var.public_key_path
  subnet_id		= module.vpc.app_subnet_id
  db_image_id		= var.db_image_id
}
