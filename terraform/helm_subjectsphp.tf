
# Local shell deploy of tls app
resource "null_resource" "subjectsphp" {

  depends_on = [null_resource.monitoring_stack]

  provisioner "local-exec" {
    command = "helm upgrade --install subjectsphp ../helm/subjectsphp --values ../helm/subjectsphp/values.yaml -n tlson --set dbpass=tfm2023"
    interpreter = local.is_windows ? ["PowerShell", "-Command"] : []
  }
}