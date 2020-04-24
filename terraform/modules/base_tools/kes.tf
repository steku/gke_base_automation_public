// terraform hack to make this module wait until prerequisite modules are complete
resource "null_resource" "module_depends_on" {
  triggers = {
    value = "${length(var.module_depends_on)}"
  }
}

resource "null_resource" "kes_namespace" {
  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/files/kes-namespace.yaml --context ${var.kubectx}"
  }
  // terraform hack to make this module wait until prerequisite modules are complete
  depends_on = [null_resource.module_depends_on]
}

// install chart in local path, the path exists outside the tf module and is part of the repository
resource "null_resource" "kes_install" {
  provisioner "local-exec" {
    command = "helm upgrade -i kes ${path.module}/../../../kubernetes-external-secrets --set env.VAULT_ADDR=${var.vault_addr} --set kes.namespace=${var.kes_namespace} -n ${var.kes_namespace} --kube-context ${var.kubectx}"
  }
  depends_on = [null_resource.kes_namespace]
}
