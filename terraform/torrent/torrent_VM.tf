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

resource "proxmox_virtual_environment_download_file" "ubuntu_img" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "proxmox"
  url          = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
}

# VM elkészítése az erőforrások és a konfiguráció megadásával
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
    dedicated = 3276
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


# resource létrehozása a docker telepítéséhez és a konténerek futtatásához
resource "null_resource" "docker_setup_and_run" {
  # Csak akkor indul el ha a VM elkészült
  # HIBA a qemu-guest-agent telepítése után azonnal csatlakozik, de a qemu-guest-agent nincs benne a telepített image-ben így azt manuálisan kell telepíteni és elindítani
  depends_on = [proxmox_virtual_environment_vm.torrent_server]

  # SSH kapcsolat beállítása a VM-hez
  connection {
    type        = "ssh"
    host        = "192.168.1.84"
    user        = "bence"
    private_key = file("~/.ssh/id_ed25519")
    timeout     = "2m"
  }

  # Távoli parancsok futtatása a VM-en a Docker telepítéséhez és konfigurálásához, a provisioner teszi lehetővé, hogy commandokat futtassunk az installációt követően és a remote-exec, pedig az mondja meg, hogy távolról hajtsa végre a parancsokat
  provisioner "remote-exec" {
    inline = [
      "export DEBIAN_FRONTEND=noninteractive",

      "sudo parted /dev/sdb --script mklabel gpt mkpart primary ext4 0% 100%",
      "sudo mkfs.ext4 -F /dev/sdb1",
      "sudo mkdir -p /mnt/hdd",
      "echo '/dev/sdb1 /mnt/hdd ext4 defaults 0 2' | sudo tee -a /etc/fstab",
      "sudo mount -a",

      "sudo apt-get remove -y docker docker-engine docker.io containerd runc || true",
      "sudo apt-get update",
      "sudo apt-get install -y ca-certificates curl gnupg lsb-release parted",
      "sudo mkdir -p /etc/apt/keyrings",
      "sudo rm -f /etc/apt/keyrings/docker.gpg",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg",
      "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
      "sudo apt-get update",
      "sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin",

      "mkdir -p /home/bence/torrent",
    ]
  }

  # fájl feltöltése a VM-re, a file provisioner teszi lehetővé, hogy fájlt töltünk fel az installáció után
  provisioner "file" {
    source      = "../torrent/docker-compose.yaml"
    destination = "/home/bence/docker-compose.yaml"
  }

  # Docker konténerek indítása a feltöltött docker-compose fájl alapján
  provisioner "remote-exec" {
  inline = [
    "mkdir -p /home/bence/torrent",
    "mv /home/bence/docker-compose.yaml /home/bence/torrent/docker-compose.yaml",
    "cd /home/bence/torrent",
    "sudo docker compose up -d"
  ]
  }
}