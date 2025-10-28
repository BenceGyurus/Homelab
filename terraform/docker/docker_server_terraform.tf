terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">=0.60.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">=3.1.0"
    }
  }
}

resource "null_resource" "docker_compose_setup" {

  connection {
    type        = "ssh"
    host        = "192.168.1.76"
    user        = "bence"
    private_key = file("~/.ssh/id_ed25519")
    timeout     = "2m"
  }


  provisioner "remote-exec" {
  inline = [
    "export DEBIAN_FRONTEND=noninteractive",
    "sudo apt install -y qemu-guest-agent",
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

    # --- Create directories ---
    "mkdir -p /home/bence/mc-server /home/bence/immich /home/bence/portainer",

  ]
}

 provisioner "file" {
    source      = "../../mc-server/docker-compose.yaml"
    destination = "/home/bence/mc-server/docker-compose.yaml"
  }
  provisioner "file" {
    source      = "../../immich/docker-compose.yaml"
    destination = "/home/bence/immich/docker-compose.yaml"
  }
  provisioner "file" {
    source      = "../../immich/.env"
    destination = "/home/bence/immich/.env"
  }


provisioner "remote-exec" {
  inline = [
    "set -a && source /home/bence/immich/.env && set +a",
    "cd /home/bence/mc-server && sudo docker compose up -d",
    "cd /home/bence/immich && sudo docker compose up -d"
  ]
}

}