terraform {
  required_providers {
    multipass = {
      source  = "larstobi/multipass"
      version = ">= 0.2.2"
    }
  }
}

provider "multipass" {}

resource "multipass_instance" "vm" {
  for_each = toset(var.vm_names)

  name           = each.value
  image          = var.vm_image
  cpus           = var.vm_cpus
  memory         = var.vm_memory
  disk           = var.vm_disk
  cloudinit_file = var.cloud_init_file
}

# Run updates automatically after each VM is created
resource "null_resource" "update_vms" {
  for_each = toset(var.vm_names)

  depends_on = [multipass_instance.vm]

  provisioner "local-exec" {
    command = <<EOT
      multipass exec ${each.key} -- sudo apt-get update -y
      multipass exec ${each.key} -- sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
    EOT
  }
}