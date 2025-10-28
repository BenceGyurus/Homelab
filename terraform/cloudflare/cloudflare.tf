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
resource "proxmox_virtual_environment_vm" "cloudflare_tunnel" {
  node_name = "proxmox"
  name      = "cloudflare-tunnel"
  started   = true

  agent{
    enabled = true
  }

  description = "Cloudflare tunnel"

  cpu {
    cores = 1
  }

  memory {
    dedicated = 396
  }


  disk {
    datastore_id = "storage"
    file_id      = proxmox_virtual_environment_download_file.latest_static_ubuntu_24_noble_qcow2_img.id
    interface    = "scsi0"
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
      address = "192.168.1.254/24"
      gateway = "192.168.1.1"
    }
  }
}
}



resource "null_resource" "docker_compose_setup" {
  depends_on = [proxmox_virtual_environment_vm.cloudflare_tunnel]

  connection {
    type        = "ssh"
    host        = "192.168.1.254"
    user        = "bence"
    private_key = file("~/.ssh/id_ed25519")
    timeout     = "2m"
    script_path = "./cloudflare.sh"
  }

  provisioner "remote-exec" {
  inline = [
    "echo 'Waiting for SSH...'",
    "for i in {1..30}; do nc -zv 192.168.1.254 22 && break || sleep 10; done",
    "echo 'SSH is up!'"
  ]
  }

  # Run setup commands remotely
  provisioner "remote-exec" {
    inline = [
      "export DEBIAN_FRONTEND=noninteractive",
      "sudo apt install qemu-guest-agent -y",
      "sudo apt-get remove -y docker docker-engine docker.io containerd runc || true",
      "sudo apt-get update",
      "sudo apt-get install -y ca-certificates curl gnupg lsb-release parted",
      "sudo mkdir -p /etc/apt/keyrings",
      "sudo rm -f /etc/apt/keyrings/docker.gpg",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg",
      "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
      "sudo apt-get update",
      "sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin",
    ]
  }

  provisioner "file" {
  source      = "./cloudflare.sh"
  destination = "/tmp/cloudflare.sh"
}

provisioner "remote-exec" {
  inline = [
    "sudo mkdir -p /home/${var.vm_username}/cloudflare-tunnel",
    "sudo mv /tmp/cloudflare.sh /home/${var.vm_username}/cloudflare-tunnel/cloudflare.sh",
    "sudo chmod +x /home/${var.vm_username}/cloudflare-tunnel/cloudflare.sh",
    "sudo /home/${var.vm_username}/cloudflare-tunnel/cloudflare.sh",
  ]
}

}