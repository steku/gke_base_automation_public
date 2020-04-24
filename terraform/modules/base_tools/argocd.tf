resource "null_resource" "argocd_namespace" {
  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/files/argocd-namespace.yaml --context ${var.kubectx}"
  }
  // terraform hack to make this module wait until prerequisite modules are complete
  depends_on = [null_resource.module_depends_on]
}

// KES CRD appears to be installed by the controller, wait until it is up and CRD is available
resource "null_resource" "wait_for_kes_crd" {
  provisioner "local-exec" {
    command = "until kubectl get crd |grep externalsecrets.kubernetes-client.io; do echo Kubernetes External Secrets CRD not yet available; sleep 5; done"
  }
  depends_on = [null_resource.kes_install]
}

// use helm to install argocd, secrets, and initial app-of-apps application
resource "null_resource" "argocd_install" {
  provisioner "local-exec" {
    command = "helm upgrade -i argocd ${path.module}/../../../argocd_base -n argocd --kube-context ${var.kubectx}"
  }
  depends_on = [null_resource.wait_for_kes_crd, null_resource.argocd_namespace]
}

// password for terraform output
data "external" "argocd_password" {
  program = ["/bin/bash", "${path.module}/files/argocd-get-password.sh"]

  query = {
    context = "${var.kubectx}"
  }

  depends_on = [null_resource.argocd_install]
}

