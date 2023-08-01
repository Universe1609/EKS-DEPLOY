provider "aws" {
  region = "us-east-2"
  default_tags {
    tags = {
      #Name = var.tag1
      #"Cost Center" = var.tag1
      Project = var.tag2
      #Torre         = var.tag3
    }
  }
}

module "vpc" {
  source = "./modules/vpc"
}

module "iam" {
  source = "./modules/iam"
}
module "eks" {
  source        = "./modules/eks"
  iam_role      = module.iam.iam_role
  iam_role_name = module.iam.iam_role_name
  private_a     = module.vpc.private_a
  private_b     = module.vpc.private_b
  public_a      = module.vpc.public_a
  public_b      = module.vpc.public_b
}
