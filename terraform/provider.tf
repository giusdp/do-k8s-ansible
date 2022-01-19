terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.16.0"
    }
  }
}

# Set the variable value in *.tfvars file
# or using -var="do_token=..." CLI option
variable "do_token" {}

variable "pvt_key" {}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}

data "digitalocean_ssh_key" "sshkey" {
  name = "sshkey"
}

data "digitalocean_project" "learnk8s" {
  name = "learnk8s"
}

resource "digitalocean_droplet" "control" {
  image  = "ubuntu-20-04-x64"
  name   = "control1"
  region = "lon1"
  size   = "s-2vcpu-4gb"
  ssh_keys = [
    data.digitalocean_ssh_key.sshkey.id
  ]
}

resource "digitalocean_droplet" "worker" {
  image  = "ubuntu-20-04-x64"
  name   = "worker1"
  region = "lon1"
  size   = "s-2vcpu-4gb"
  ssh_keys = [
    data.digitalocean_ssh_key.sshkey.id
  ]
}

resource "digitalocean_project_resources" "learnk8s-droplets" {
  project = data.digitalocean_project.learnk8s.id
  resources = [
    digitalocean_droplet.control.urn,
    digitalocean_droplet.worker.urn,
  ]
}

output "control_ip_address" {
  value = digitalocean_droplet.control.ipv4_address
}

output "worker_ip_address" {
  value = digitalocean_droplet.worker.ipv4_address
}

resource "local_file" "hosts" {
  content = templatefile("hosts.tmpl",
    {
      control_ip = digitalocean_droplet.control.ipv4_address
      worker_ip  = digitalocean_droplet.worker.ipv4_address
    }
  )
  filename = "../ansible/hosts.ini"
}
