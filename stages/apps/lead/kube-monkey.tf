module "kube_monkey" {
  source    = "../../../modules/tools/kube-monkey"
  count     = var.enable_kube_monkey ? 1 : 0
  namespace = var.monitoring_namespace
}
