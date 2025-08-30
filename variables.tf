variable "vm_names" {
  description = "Names of the VMs to create"
  type        = list(string)
  default     = ["tf-node1", "tf-node2"]
}

variable "vm_image" {
  description = "Ubuntu release to use"
  type        = string
  default     = "24.04"
}

variable "vm_cpus" {
  description = "Number of CPUs per VM"
  type        = number
  default     = 2
}

variable "vm_memory" {
  description = "RAM per VM"
  type        = string
  default     = "2G"
}

variable "vm_disk" {
  description = "Disk size per VM"
  type        = string
  default     = "20G"
}

variable "cloud_init_file" {
  description = "Cloud-init configuration file"
  type        = string
  default     = "cloud-init.yaml"
}
