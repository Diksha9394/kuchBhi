provider "google" {  
  project  = "fanpoc-automation-310113"  // Provide project id
  region   = "europe-west2"  
  credentials = file("C:/Users/fantest3/Downloads/fanpoc-automation.json")
}
resource "google_compute_network" "gcp_vpc" {
  name                    = "gcpmigration" // Provide project name
  project                 =  "fanpoc-automation-310113" // Project ID
  auto_create_subnetworks = false
 }

resource "google_compute_route" "gcp_route1" { 
 name        = "route" 
 project     = "fanpoc-automation-310113"
 dest_range  = "0.0.0.0/0"
 network     = google_compute_network.gcp_vpc.name 
 next_hop_gateway = "default-internet-gateway" 
 priority    = 100 
} 

resource "google_compute_firewall" "gcp_firewall1" { 
 name    = "firewall" 
 network = google_compute_network.gcp_vpc.name 
 priority = 1000 
 direction = "INGRESS" 
 source_ranges = ["0.0.0.0/0"] 
 allow { 
  protocol = "tcp" 
  ports    = ["80","8080","3389","443","8983","8984"] 
  } 
} 

resource "google_compute_firewall" "gcp_firewall2" { 
 name    = "firewallpri" 
 network = google_compute_network.gcp_vpc.name 
 priority = 1000 
 direction = "INGRESS" 
 source_ranges = ["172.31.3.0/24"] 
 allow { 
  protocol = "tcp" 
  ports    = ["8983","80","443","8080","8984","1433","6378","22"] 
  } 
} 

resource "google_compute_subnetwork" "gcp_subnet1" { 
 name             = "subnetpub" 
 ip_cidr_range    = "172.31.2.0/24" 
 network          = google_compute_network.gcp_vpc.name 
 region           = "europe-west2" 
 private_ip_google_access = true 
} 
resource "google_compute_subnetwork" "gcp_subnet2" { 
 name             = "subnetpri" 
 ip_cidr_range    = "172.31.3.0/24" 
 network          = google_compute_network.gcp_vpc.name 
 region           = "europe-west2" 
 private_ip_google_access = true 
} 

/*
resource "google_container_node_pool" "kubernetes-cluster-node-pool1" { 
 name       = "fancluster-nodes" 
 project    = "fanpoc-automation-310113" // "kapil-k8-project" // "fanpoc-automation-310113" 
 cluster    = google_container_cluster.kubernetes-cluster1.name 
 location   = "europe-west2-a" 
 version       = "1.18.16-gke.502" 
 node_count = "1" 
 node_config { 
  machine_type = "n1-standard-16"     
  oauth_scopes = ["compute-rw","storage-full","pubsub","logging-write","service-control","service-management","monitoring","bigquery", 
  "cloud-platform","cloud-source-repos","cloud-source-repos-ro","datastore","service-control","service-management","taskqueue", 
  "https://www.googleapis.com/auth/projecthosting","monitoring","monitoring-write","storage-rw","sql-admin"] 
  tags = ["manchesterunited", "gcpmigration-diksha-a"] 
 } 
 autoscaling { 
  min_node_count = "3" 
  max_node_count = "3" 
 } 
 management { 
  auto_repair  = true 
  auto_upgrade  = true 
 } 
} 
*/ 




resource "google_compute_instance" "vm_instance1" {
 name         = "jump"
 machine_type = "n1-standard-4"
 zone         = "europe-west2-a"
 tags         =  ["web"]
 boot_disk {
  initialize_params {
   image = "windows-cloud/windows-2019"
   size = "100"
   type = "pd-standard"
  }
 }
 network_interface {
  subnetwork  = google_compute_subnetwork.gcp_subnet1.name 

  access_config {}
 }
}


//  access_config {}
 

/*
resource "google_redis_instance" "cache" {
  name           = "ha-memory-cache"
  tier           = "STANDARD_HA"
  memory_size_gb = 4

  location_id             = "europe-west2-b"
  alternative_location_id = "europe-west2-c"

  authorized_network = data.google_compute_network.redis-network.id

  redis_version     = "REDIS_4_0"
  display_name      = "GCP Migration"
  reserved_ip_range = "172.31.0.0/29"
  auth_enabled      = "true"

  labels = {
    my_key    = "my_val"
    other_key = "other_val"
  }
}
data "google_compute_network" "redis-network" {
  name = "gcpmigration"
}
*/
/*
Script for Database Instance
*/



