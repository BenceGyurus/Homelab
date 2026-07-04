terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">=0.60.0"
    }
  }
}

# csatlakotás a proxmox-hoz

provider "proxmox" {
  endpoint = var.proxmox_host
  username = var.proxmox_username
  password = var.proxmox_password
  insecure = true
}

# változó létrehozása a felhasználónévnek amit a környezeti változókból szed ki

variable "proxmox_username" {
  description = "Proxmox username"
  type        = string
}

# változó létrehozása a jelszónak

variable "proxmox_password" {
  description = "Proxmox password"
  type        = string
  sensitive   = true
}

# változó a proxmox IP-jéhez

variable "proxmox_host" {
  description = "Proxmox host URL"
  type        = string
}

# változó a VM felhasználónevéhez

variable "vm_username" {
  description = "VM username"
  type        = string
}


# változó a VM felhasználónévnek

variable "vm_password" {
  description = "VM password"
  type        = string
  sensitive   = true
}

# Letöltjük az Ubuntu 24.04 ISO fájlt ami a proxmox_virtual_environment_download_file ban lesz


# VM elkészítése az erőforrások és a konfiguráció megadásával
resource "proxmox_virtual_environment_vm" "vpn" {
  node_name = "proxmox"
  name      = "vpn"
  started   = true

  agent{
    enabled = true
  }

  description = "VPN for a filtered and managed network"

  cpu {
    cores = 1
  }

  memory {
    dedicated = 1024
  }

    clone {
        vm_id         = 110
        node_name     = "proxmox"
        full = true
        target = "TB1"
    }

    disk {
        datastore_id = "TB1"
        interface    = "scsi0"
        size		 = 20 
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
    vlan_id = 99
  }

  initialization {

    dns{
        servers = ["192.168.99.250"]
    }

    ip_config {
        ipv4 {
        address = "192.168.99.252/24"
        gateway = "192.168.99.1"
        }
    }
    }
}

