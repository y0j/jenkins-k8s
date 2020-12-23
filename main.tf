terraform {
  required_version = ">= 0.12"
}

provider "kubernetes" {
  config_context_cluster = "minikube"
}

resource "kubernetes_namespace" "jenkins_namespace" {
  metadata {
    name = "jenkins"
  }
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "jenkins" {
  name       = "jenkins"
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  version    = "3.0.8"
  namespace  = "jenkins"

  values = [
    file("helm/values.yaml")

    # Alternatively, we can use templatefile function
    # in case we need to pass a variable to the values.yaml
    # It should be reflected inside the values.yaml as well,
    # e.g. tag: "${myvar}"
    # templatefile("helm/values.yaml", { myvar = "${var.myvar}" })
  ]
}
