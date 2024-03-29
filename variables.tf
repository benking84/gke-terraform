variable "region" {
  type    = "string"
  default = "australia-southeast1"
}

variable "zone" {
  type    = "string"
  default = "australia-southeast1-b"
}

variable "project" {
  type    = "string"
  default = "REPLACE_ME"
}

variable "billing_account" {
  type = "string"
  default = "REPLACE_ME"
}

variable "org_id" {
  type = "string"
  default = "REPLACE_ME"
}

variable "instance_type" {
  type    = "string"
  default = "n1-standard-2"
}

variable "service_account_iam_roles" {
  type = "list"

  default = [
    "roles/resourcemanager.projectIamAdmin",
    "roles/container.admin",
    "roles/iam.serviceAccountAdmin",
    "roles/iam.serviceAccountKeyAdmin",
    "roles/iam.serviceAccountTokenCreator",
    "roles/iam.serviceAccountUser",
    "roles/viewer",
  ]
}

variable "project_services" {
  type = "list"

  default = [
    "cloudkms.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "container.googleapis.com",
    "containerregistry.googleapis.com",
    "iam.googleapis.com",
  ]
}


variable "kms_crypto_key_roles" {
  type = "list"

  default = [
    "roles/cloudkms.cryptoKeyEncrypterDecrypter",
  ]
}

variable "kubernetes_version" {
  type    = "string"
  default = "1.12.7-gke.10"
}

variable "kubernetes_logging_service" {
  type    = "string"
  default = "logging.googleapis.com/kubernetes"
}

variable "kubernetes_monitoring_service" {
  type    = "string"
  default = "monitoring.googleapis.com/kubernetes"
}

variable "num_pool_servers" {
  type    = "string"
  default = "3"
}
