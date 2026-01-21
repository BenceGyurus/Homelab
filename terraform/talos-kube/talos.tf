terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">=0.60.0"
    }
  }
}

provider "proxmox" {
  endpoint = var.proxmox_host
  username = var.proxmox_username
  password = var.proxmox_password
  insecure = true
}


variable "proxmox_username" {
  description = "Proxmox username"
  type        = string
}

variable "proxmox_password" {
  description = "Proxmox password"
  type        = string
  sensitive   = true
}

variable "proxmox_host" {
  description = "Proxmox host URL"
  type        = string
}

variable "vm_username" {
  description = "VM username"
  type        = string
}

variable "vm_password" {
  description = "VM password"
  type        = string
  sensitive   = true
}

resource "proxmox_virtual_environment_download_file" "talos_img" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "proxmox"
  url          = "https://factory.talos.dev/image/ce4c980550dd2ab1b17bbf2b08801c7eb59418eafe8f279833297925d67c7515/v1.12.1/nocloud-amd64.iso"
  overwrite    = true
}

# Create the Ubuntu VM
resource "proxmox_virtual_environment_vm" "talos_vm" {
  node_name = "proxmox"
  name      = "talos-vm"
  started   = true

  agent{
    enabled = true
  }

  description = "Talos vm for k8s"

  cpu {
    cores = 2
  }

  memory {
    dedicated = 8192
  }


  disk {
    datastore_id = "TB1"
    size         = 30
    interface    = "scsi0"
  }

  cdrom {
    file_id      = proxmox_virtual_environment_download_file.talos_img.id
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }


  initialization {
  user_account {
    username = var.vm_username
    password = var.vm_password
    keys     = [file("~/.ssh/id_ed25519.pub")]
  }

  ip_config {
    ipv4 {
      address = "192.168.1.86/24"
      gateway = "192.168.1.1"
    }
  }
}
}

