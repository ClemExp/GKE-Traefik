# resource "google_compute_global_forwarding_rule" "https_forwarding_rule" {
#   name       = "https-forwarding-rule"
#   target     = google_compute_target_https_proxy.https_proxy.self_link
#   ip_address = google_compute_global_address.default.address
#   port_range = "443"
#   depends_on = [null_resource.traefik_deploy]
# }

# resource "google_compute_target_https_proxy" "https_proxy" {
#   name        = "https-proxy"
#   url_map     = google_compute_url_map.url_map.self_link
#   ssl_certificates = [google_compute_ssl_certificate.default.id]
#   depends_on = [null_resource.traefik_deploy]
# }

# resource "google_compute_url_map" "url_map" {
#   name = "url-map"

#   default_url_redirect {
#     https_redirect = true
#     strip_query    = false
#   }
#   depends_on = [null_resource.traefik_deploy]
# }

# resource "google_compute_ssl_policy" "ssl_policy" {
#   name    = "ssl-policy"
#   profile = "MODERN"
#   depends_on = [null_resource.traefik_deploy]
# }

# following 3 resources will be part of the backend for load balancer - which we will reference in traefik helm during service deploy
resource "google_compute_backend_service" "backend_service" {
  name = "traefik-backend-service"
  port_name = "https"
  protocol = "HTTPS"

  health_checks = [google_compute_https_health_check.traefik_health_check.id]

  backend {
    group = google_compute_instance_group.traefik_instances.self_link
  }
  depends_on = [null_resource.cluster_tls]
}

resource "google_compute_https_health_check" "traefik_health_check" {
  name               = "traefik-health-check"
  request_path       = "/healthcheck"
  check_interval_sec = 10
  timeout_sec        = 5
  unhealthy_threshold = 3
  healthy_threshold  = 2
  depends_on = [null_resource.cluster_tls]
}

resource "google_compute_instance_group" "traefik_instances" {
  name = "traefik-instances"
  named_port {
    name = "https"
    port = 32443
  }
  # coming in with null values! so TF can't create instance group
  instances = compact(data.google_compute_instance.cluster_nodes.*.id)

  depends_on = [null_resource.cluster_tls]
}