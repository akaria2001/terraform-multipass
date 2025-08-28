terraform {
  required_version = ">= 1.5.0"

  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}

resource "null_resource" "multipass_vm" {
  triggers = {
    vm_name        = var.vm_name
    image          = var.image
    cpus           = tostring(var.cpus)
    memory         = var.memory
    disk           = var.disk
    cloudinit_hash = filesha256("${path.module}/${var.cloud_init}")
  }

  provisioner "local-exec" {
    command = <<-EOT
      set -e

      # Wait for Multipass daemon to be ready (retry up to 12 times, 5s apart)
      echo "Checking Multipass daemon..."
      for i in {1..12}; do
        if multipass list >/dev/null 2>&1; then
          echo "Multipass daemon is running."
          break
        fi
        echo "Waiting for Multipass daemon..."
        sleep 5
      done

      # Launch VM if it doesn't exist
      if multipass info ${var.vm_name} >/dev/null 2>&1; then
        echo "VM '${var.vm_name}' already exists. Skipping launch."
      else
        echo "Launching VM '${var.vm_name}' with cloud-init..."
        multipass launch ${var.image} \
          --name ${var.vm_name} \
          --cpus ${var.cpus} \
          --memory ${var.memory} \
          --disk ${var.disk} \
          --cloud-init "${var.cloud_init}"
        echo "VM launched."
      fi

      # Wait until VM is running
      echo "Waiting for VM '${var.vm_name}' to be ready..."
      for i in {1..20}; do
        if multipass info ${var.vm_name} | grep -q "Running"; then
          echo "VM is running."
          break
        fi
        sleep 5
      done

      echo "VM creation complete."
    EOT
    interpreter = ["/bin/bash", "-lc"]
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      set -e
      echo "Deleting VM '${self.triggers.vm_name}'..."
      multipass delete ${self.triggers.vm_name} --purge || true
      echo "Deleted VM '${self.triggers.vm_name}'."
    EOT
    interpreter = ["/bin/bash", "-lc"]
  }
}

output "ssh_command" {
  value       = "multipass shell ${var.vm_name}"
  description = "Run this to shell into the VM."
}
