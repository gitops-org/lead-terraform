terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.3.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.4.1"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "3.59.0"
    }
  }
}
