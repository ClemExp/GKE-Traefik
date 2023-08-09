# Local shell deploy of exisitng traefik chart - injecting environment = subdomain
resource "null_resource" "traefik_deploy" {

  depends_on = [google_compute_backend_service.backend_service]

  provisioner "local-exec" {
    command = "helm install traefik ../helm/traefik-dashboard --values ../helm/traefik-dashboard/values.yaml --set varsubdomain='clemoregan.com' -n tlson --create-namespace"
    interpreter = local.is_windows ? ["PowerShell", "-Command"] : []
  }
}