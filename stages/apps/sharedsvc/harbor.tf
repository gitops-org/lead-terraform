data "vault_generic_secret" "harbor" {
  path = "lead/aws/${data.aws_caller_identity.current.account_id}/harbor"
}

locals {
  harbor_hostname = "harbor.${var.cluster_domain}"
}

module "harbor_namespace" {
  source    = "../../../modules/common/namespace"
  namespace = "harbor"
}

module "harbor" {
  source = "../../../modules/tools/harbor"

  harbor_ingress_hostname      = local.harbor_hostname
  ingress_annotations          = local.external_ingress_annotations
  namespace                    = module.harbor_namespace.name
  admin_password               = data.vault_generic_secret.harbor.data["admin-password"]
  k8s_storage_class            = var.k8s_storage_class
  harbor_registry_disk_size    = "200Gi"
  harbor_chartmuseum_disk_size = "100Gi"
}
