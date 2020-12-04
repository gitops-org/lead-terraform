module "eks" {
  source                           = "../../../../modules/environment/aws/lambda-ebs-volume-cleanup"
  region                           = var.region
  count                            = var.enable_lambda_ebs_volume_count ? 1 : 0
}
