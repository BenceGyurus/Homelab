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

resource "proxmox_virtual_environment_download_file" "ubuntu_img" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "proxmox"
  url          = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
}

# Create the Ubuntu VM
resource "proxmox_virtual_environment_vm" "torrent_server" {
  node_name = "proxmox"
  name      = "torrent-server"
  started   = true

  agent{
    enabled = true
  }

  description = "Torrent server VM with Docker"

  cpu {
    cores = 2
  }

  memory {
    dedicated = 4096
  }


  disk {
    datastore_id = "storage"
    file_id      = proxmox_virtual_environment_download_file.ubuntu_img.id
    interface    = "scsi0"
  }

  disk {
    interface    = "scsi1"
    datastore_id = "storage"
    size         = 800
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
      address = "192.168.1.84/24"
      gateway = "192.168.1.1"
    }
  }
}
}

resource "null_resource" "docker_compose_setup" {
  depends_on = [proxmox_virtual_environment_vm.torrent_server]

  connection {
    type        = "ssh"
    host        = "192.168.1.84"
    user        = "bence"
    private_key = file("~/.ssh/id_ed25519")
    timeout     = "2m"
  }

  # Run setup commands remotely
  provisioner "remote-exec" {
    inline = [
      "export DEBIAN_FRONTEND=noninteractive",
      "sudo apt install qemu-guest-agent -y",
      "sudo systemctl enable --now qemu-guest-agent",
      # --- Create partition, format, and mount the 800GB disk ---
      "sudo parted /dev/sdb --script mklabel gpt mkpart primary ext4 0% 100%",
      "sudo mkfs.ext4 -F /dev/sdb1",
      "sudo mkdir -p /mnt/hdd",
      "echo '/dev/sdb1 /mnt/hdd ext4 defaults 0 2' | sudo tee -a /etc/fstab",
      "sudo mount -a",

      # --- Install Docker ---
      "sudo apt-get remove -y docker docker-engine docker.io containerd runc || true",
      "sudo apt-get update",
      "sudo apt-get install -y ca-certificates curl gnupg lsb-release parted",
      "sudo mkdir -p /etc/apt/keyrings",
      "sudo rm -f /etc/apt/keyrings/docker.gpg",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg",
      "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
      "sudo apt-get update",
      "sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin",

      # --- Start your docker-compose stack ---
      "mkdir -p /home/bence/torrent",
    ]
  }

  provisioner "file" {
    source      = "../torrent/docker-compose.yaml"
    destination = "/home/bence/docker-compose.yaml"
  }


  provisioner "remote-exec" {
  inline = [
    "mkdir -p /home/bence/torrent",
    "mv /home/bence/docker-compose.yaml /home/bence/torrent/docker-compose.yaml",
    "cd /home/bence/torrent",
    "sudo docker compose up -d"
  ]
  }
}