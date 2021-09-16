resource "helm_release" "kube_monkey" {
  name       = "kube-monkey"
  namespace  = var.namespace
  repository = "https://asobti.github.io/kube-monkey/charts/repo"
  chart      = "kube-monkey"
  version    = var.chart_version
  timeout    = 600
  wait       = true

  values = [
    templatefile("${path.module}/kube-monkey-values.tpl", {
      app_version = var.app_version
      run_hour    = var.run_hour
      start_hour  = var.start_hour
      end_hour    = var.end_hour
      timezone    = var.timezone
    })
  ]
}
