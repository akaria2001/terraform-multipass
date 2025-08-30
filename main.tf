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
