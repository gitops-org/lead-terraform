module "ebs_volume_cleanup" {
  source                           = "../../../../modules/environment/aws/ebs-volume-cleanup"
  cluster                          = var.cluster_name
  count                            = var.enable_ebs_count ? 1 : 0
}
