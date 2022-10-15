# ___________________________________________________
# My Terraform
#
# Terraform: Google Cloud Platform
#
# Made by AV
# ___________________________________________________

# export GOOGLE_CLOUD_KEYFILE_JSON="gcp-cred.json"

provider "google" {
  credentials = file("gcp-cred.json") # файл с credentials
  project     = "project_id"          # номер проекта из GCP
  region      = "us-west1"
  zone        = "us-west1-b"
}

resource "google_compute_instance" "server" {
  name         = "gcp-server" # нижние подчеркивания нельзя использовать
  machine_type = "f1-micro"   # тип инстанса
  boot_disk {    
    initialize_params {
      image = "debian-cloud/debian-9"  # образ операционной системы
    }
  }
  network_interface {
    network = "default"      # обязательно указываем сеть
  }
}
