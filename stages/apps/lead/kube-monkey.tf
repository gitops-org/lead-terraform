module "kube_monkey" {
  source     = "../../../modules/tools/kube-monkey"
  count      = var.enable_kube_monkey ? 1 : 0
  namespace  = var.monitoring_namespace
  start_hour = 10
  end_hour   = 17
  run_hour   = 9
}
