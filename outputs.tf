output "vm_names" {
  description = "Names of the created VMs"
  value       = [for vm in multipass_instance.vm : vm.name]
}
