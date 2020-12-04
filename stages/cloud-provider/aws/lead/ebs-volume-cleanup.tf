module "ebs_volume_cleanup" {
  source                           = "../../../../modules/environment/aws/ebs-volume-cleanup"
  region                           = var.region
  count                            = var.enable_ebs_count ? 1 : 0
}
