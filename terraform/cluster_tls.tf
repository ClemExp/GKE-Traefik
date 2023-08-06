# First ensure that we are pointing to the correct cluster - reconfiguring kubeconfig
resource "null_resource" "establish_cluster" {
  depends_on = [google_container_cluster.primary]

  provisioner "local-exec" {
    interpreter = local.is_windows ? ["PowerShell", "-Command"] : ["/bin/bash", "-c"]
    command = <<EOT
      set -e
      echo 'Reconfiguring kubeconfig...'
      gcloud container clusters get-credentials $(terraform output -raw kubernetes_cluster_name) --zone $(terraform output -raw zone) --project $(terraform output -raw project)
    EOT
  }
}

# Deploy of Lets encrypt CA generated certificates - post cluster create
# Creating namespace and secret for traefik & applications: for custom or services apps
resource "null_resource" "cluster_tls" {

  depends_on = [null_resource.establish_cluster]

  provisioner "local-exec" {
    interpreter = local.is_windows ? ["PowerShell", "-Command"] : ["/bin/bash", "-c"]
    command = <<EOT
      set -e
      echo 'Applying TLS Config with kubectl...'
      kubectl create namespace tlson
      kubectl -n tlson create configmap traefik-cert --from-file=../helm/certs/fullchain.pem
      kubectl -n tlson create configmap traefik-key --from-file=../helm/certs/privkey.pem
      kubectl -n tlson create secret tls traefik-tls-cert --key=../helm/certs/privkey.pem --cert=../helm/certs/fullchain.pem
    EOT
  }
}

#Import self managed certificate into GCP, so it can be used when creating an ingress for LB - traefik
resource "google_compute_ssl_certificate" "default" {
  name        = "self-managed-cert"
  description = "Global cert"
  project     = var.project
  certificate = file("../helm/certs/fullchain.pem")
  private_key = file("../helm/certs/privKey.pem")
  #scope       = "DEFAULT"
  #location    = "global"
  #self_managed {
  #  pem_certificate = file("../helm/certs/fullchain.pem")
  #  pem_private_key = file("../helm/certs/privkey.pem")
  #}

  depends_on = [null_resource.establish_cluster]
}

# create static address which will be later used by the load balancer config
resource "google_compute_global_address" "default" {
  name           = "traefike2e-lb-static-ip"
  address_type   = "EXTERNAL"
}