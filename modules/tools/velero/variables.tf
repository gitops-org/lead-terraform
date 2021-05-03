variable "bucket_name" {}
variable "region" {}
variable "cluster_name" {}
variable "namespace" {}
variable "velero_service_account_arn" {}
variable "velero_enabled_namespaces" {
  type = list(string)
}