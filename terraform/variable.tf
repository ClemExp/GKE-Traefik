variable "project" {
  type = string
}

variable "credentials_file" {}

variable "google_dns_sa_file" {}

variable "region" {
  default = "europe-southwest1"
}

variable "zone" {
  default = "europe-southwest1-a"
}
