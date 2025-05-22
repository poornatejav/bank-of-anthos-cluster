provider "aws" {
  region = "us-east-1"
}

module "iam" {
  source = "../../modules/iam"
  env    = var.env
}

module "vpc" {
  source               = "../../modules/vpc"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  azs                  = ["us-east-1a", "us-east-1b"]
  env                  = var.env
}

module "eks" {
  source                  = "../../modules/eks"
  env                     = var.env
  subnet_ids              = module.vpc.private_subnets
  cluster_role_arn        = module.iam.cluster_role_arn
  cluster_role_attachment = module.iam.cluster_role_attachment
  node_role_arn           = module.iam.node_role_arn
}

module "monitoring" {
  source = "../../modules/monitoring"
  cluster_name        = module.eks.cluster_name
  cluster_endpoint    = module.eks.cluster_endpoint
  cluster_ca_data     = module.eks.cluster_ca_data
}

module "gitops" {
  source = "../../modules/gitops"

  cluster_name     = module.eks.cluster_name
  cluster_endpoint = module.eks.cluster_endpoint
  cluster_ca_data  = module.eks.cluster_ca_data


  # depends_on = [module.eks]
}


module "ingress_nginx" {
  source = "../../helm_ingress_nginx"
}

module "ingress_rules" {
  source = "../../ingress_rules"
}