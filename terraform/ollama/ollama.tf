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

resource "proxmox_virtual_environment_download_file" "latest_static_ubuntu_24_noble_qcow2_img" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "proxmox"
  url          = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
  overwrite    = false
}

# Create the Ubuntu VM
resource "proxmox_virtual_environment_vm" "ollama_vm" {
  node_name = "proxmox"
  name      = "ollama-vm"
  started   = true

  agent{
    enabled = true
  }

  description = "Ollama VM"

  cpu {
    cores = 8
  }

  memory {
    dedicated = 16384
  }


  disk {
    datastore_id = "TB1"
    file_id      = proxmox_virtual_environment_download_file.latest_static_ubuntu_24_noble_qcow2_img.id
    interface    = "scsi0"
    size         = 30
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
      address = "192.168.1.249/24"
      gateway = "192.168.1.1"
    }
  }
}
}



resource "null_resource" "docker_compose_setup" {
  depends_on = [proxmox_virtual_environment_vm.ollama_vm]

  connection {
    type        = "ssh"
    host        = "192.168.1.249"
    user        = "bence"
    private_key = file("~/.ssh/id_ed25519")
    timeout     = "2m"
  }


  provisioner "file" {
  source      = "../../openWebUI/docker-compose.yaml"
  destination = "/tmp/docker-compose.yaml"
  }

  provisioner "file" {
  source      = "../docker_install.sh"
  destination = "/tmp/docker_install.sh"
  }

provisioner "remote-exec" {
  inline = [
    "export DEBIAN_FRONTEND=noninteractive",
    "mkdir -p ~/openWebUI",
    "sudo chmod +x /tmp/docker_install.sh",
    "sudo /tmp/docker_install.sh",
    "sudo mv /tmp/docker-compose.yaml ~/openWebUI/docker-compose.yaml",
    "cd ~/openWebUI",
    
    "curl -fsSL https://ollama.com/install.sh | sh",
    "ollama pull llama3.1:8b",
  ]
}

}