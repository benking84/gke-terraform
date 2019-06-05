provider "google-beta" {
  credentials = "${file("account.json")}"
  }

# Create the service account
resource "google_service_account" "terraform-sc1" {
  account_id   = "terraform-sc1"
  display_name = "terraform-sc1"
  project      = "${var.project}"
}

# Create a service account key
resource "google_service_account_key" "benjking-service-key" {
  service_account_id = "${google_service_account.terraform-sc1.name}"
}

# Add the service account to the project
resource "google_project_iam_member" "service-account" {
  count   = "${length(var.service_account_iam_roles)}"
  project = "${var.project}"
  role    = "${element(var.service_account_iam_roles, count.index)}"
  member  = "serviceAccount:${google_service_account.terraform-sc1.email}"
}

# Enable required services on the project
resource "google_project_service" "service" {
  count   = "${length(var.project_services)}"
  project = "${var.project}"
  service = "${element(var.project_services, count.index)}"

  # Do not disable the service on destroy.
  disable_on_destroy = false
}


resource "google_container_cluster" "benjking-test" {
  name     = "benjking-test-cluster"
  project = "${var.project}"
  location    = "${var.zone}"

  min_master_version = "${var.kubernetes_version}"
  node_version       = "${var.kubernetes_version}"
  logging_service    = "${var.kubernetes_logging_service}"
  monitoring_service = "${var.kubernetes_monitoring_service}"

  #initial_node_count = 1

  remove_default_node_pool = true
  initial_node_count = 1

  master_auth {
    username = ""
    password = ""
  }
}

resource "google_container_node_pool" "benjking-node-pool-1" {
  name       = "benjking-node-pool-1"
  project = "${var.project}"
  location   = "${var.zone}"
  cluster    = "${google_container_cluster.benjking-test.name}"
  node_count = "${var.num_pool_servers}"

  #initial_node_count  = 1

  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

  management {
    auto_repair = true
    auto_upgrade = false
  }
  node_config {
    preemptible  = true
    machine_type = "n1-standard-1"

    #metadata {
    #  disable-legacy-endpoints = "true"
    #}

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

resource "google_container_node_pool" "benjking-node-pool-2" {
  name       = "benjking-node-pool-2"
  project = "${var.project}"
  location   = "${var.zone}"
  cluster    = "${google_container_cluster.benjking-test.name}"
  node_count = "${var.num_pool_servers}"

  node_config {
    machine_type = "n1-standard-2"

    #metadata {
     # disable-legacy-endpoints = "true"
    #}

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
  depends_on = ["google_container_cluster.benjking-test"]
}

# The following outputs allow authentication and connectivity to the GKE Cluster
# by using certificate-based authentication.
output "client_certificate" {
  value = "${google_container_cluster.benjking-test.master_auth.0.client_certificate}"
}

output "client_key" {
  value = "${google_container_cluster.benjking-test.master_auth.0.client_key}"
}

output "cluster_ca_certificate" {
  value = "${google_container_cluster.benjking-test.master_auth.0.cluster_ca_certificate}"
}