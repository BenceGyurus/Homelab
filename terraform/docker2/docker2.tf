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
resource "proxmox_virtual_environment_vm" "docker2" {
  node_name   = "proxmox"
  name        = "docker2"
  started     = true
  description = "DockerVM to runnin VMs which do not need "

  agent {
    enabled = true
  }

  cpu {
    cores = 2
  }

  memory {
    dedicated = 2048
  }

  clone {
    vm_id     = 110
    node_name = "proxmox"
    full      = true
  }

  disk {
    datastore_id = "TB1"
    interface    = "scsi0"
    size         = 80 
  }

  network_device {
    bridge  = "vmbr0"
    model   = "virtio"
    vlan_id = 100
  }

  initialization {
    dns {
      servers = ["8.8.8.8", "1.1.1.1"]
    }

    ip_config {
      ipv4 {
        address = "192.168.100.18/24"
        gateway = "192.168.100.1"
      }
    }
  }
}

resource "null_resource" "docker_setup_and_run" {
  # Csak akkor indul el ha a VM elkészült
  # HIBA a qemu-guest-agent telepítése után azonnal csatlakozik, de a qemu-guest-agent nincs benne a telepített image-ben így azt manuálisan kell telepíteni és elindítani
  depends_on = [proxmox_virtual_environment_vm.docker2]

  # SSH kapcsolat beállítása a VM-hez
  connection {
    type        = "ssh"
    host        = "192.168.100.18"
    user        = "bence"
    private_key = file("~/.ssh/id_ed25519")
    timeout     = "2m"
  }


  provisioner "remote-exec" {
  inline = [
    "sudo apt install qemu-guest-agent -y",
    "sudo systemctl restart qemu-guest-agent"
  ]
  }


  # fájl feltöltése a VM-re, a file provisioner teszi lehetővé, hogy fájlt töltünk fel az installáció után
  provisioner "file" {
    source      = "../install-docker-on-debian.sh"
    destination = "/home/bence/install-docker.sh"
  }

  # Docker konténerek indítása a feltöltött docker-compose fájl alapján
  provisioner "remote-exec" {
  inline = [
    "sudo chmod +x /home/bence/install-docker.sh",
    "sudo bash /home/bence/install-docker.sh",
    "sudo docker run -d -p 9001:9001 --name portainer_agent --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/docker/volumes:/var/lib/docker/volumes -v /:/host portainer/agent:2.39.5"
  ]
  }
}