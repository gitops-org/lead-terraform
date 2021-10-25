resource "time_static" "current_time" {}

provider "aws" {
  region = var.region
}

data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

data "aws_caller_identity" "current" {}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
    command     = "aws"
  }
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
      command     = "aws"
    }
  }
}

locals {
  test_name = "cert-manager-test-${time_static.current_time.unix}"
  openid_connect_provider_url = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
  openid_connect_provider_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${trimprefix(local.openid_connect_provider_url, "https://")}"
}

resource "kubernetes_namespace" "test_harness" {
  metadata {
    name = local.test_name
  }
}

// first module under test - IAM configuration for cert-manager
module "cert_manager_iam" {
  source = "../../../../environment/aws/iam/cert-manager"

  cluster                     = local.test_name
  namespace                   = local.test_name
  openid_connect_provider_url = local.openid_connect_provider_url
  openid_connect_provider_arn = local.openid_connect_provider_arn
}

resource "test_assertions" "iam" {
  component = "iam"

  check "non_empty_role_arn" {
    description = "cert-manager IAM role created successfully"
    condition = module.cert_manager_iam.cert_manager_service_account_arn != ""
  }
}
