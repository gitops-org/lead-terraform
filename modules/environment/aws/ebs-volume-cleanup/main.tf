module "lambda" {
  source = "./lambda.tf"
  region                           = var.cluster
  count                            = var.enable_ebs_count
}