
# Local shell deploy of tls app
resource "null_resource" "whoami" {

  depends_on = [null_resource.monitoring_stack]

  provisioner "local-exec" {
    command = "helm install whoami ../helm/whoami --values ../helm/whoami/values.yaml -n tlson"
    interpreter = local.is_windows ? ["PowerShell", "-Command"] : []
  }
}