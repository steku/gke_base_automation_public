// terraform hack to make sure prerequisite modules have completed
resource "null_resource" "module_depends_on" {
  triggers = {
    value = "${length(var.module_depends_on)}"
  }
}

// get the KES service account token from k8s cluster for vault config
data "external" "config_vault" {
  program = ["/bin/bash", "${path.module}/files/config-vault.sh"]

  query = {
    context       = "${var.kubectx}"
    kes_namespace = "${var.kes_namespace}"
  }

  depends_on = [null_resource.module_depends_on]
}

// vault kubernetes auth enable
resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
  path = var.vault_auth_path
}

// configure auth endpoint for our K8s cluster
resource "vault_kubernetes_auth_backend_config" "demo" {
  backend            = vault_auth_backend.kubernetes.path
  kubernetes_host    = var.cluster_endpoint
  kubernetes_ca_cert = base64decode(var.cluster_ca)
  token_reviewer_jwt = base64decode(lookup(data.external.config_vault.result, "kube_token"))
}

// create a new Vault role on this path
resource "vault_kubernetes_auth_backend_role" "kes" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = var.vault_role_name
  bound_service_account_names      = var.kes_service_account
  bound_service_account_namespaces = [var.kes_namespace]
  token_ttl                        = 3600
  token_policies                   = var.token_policies
}

// create a Vault policy using a template to access our secrets
data "template_file" "vault_policy" {
  template = "${file("${path.module}/templates/vault_policy.tpl")}"
  vars = {
    vault_kes_path         = var.vault_kes_path
  }
}

// apply the rendered template to the Vault instance
resource "vault_policy" "kes" {
  name   = "kes"
  policy = data.template_file.vault_policy.rendered
}