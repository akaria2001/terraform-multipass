variable "vm_name" {
  description = "Multipass instance name"
  type        = string
  default     = "tf-demo"
}

variable "image" {
  description = "Ubuntu image alias (e.g., 22.04, 24.04)"
  type        = string
  default     = "24.04"
}

variable "cpus" {
  description = "vCPU count"
  type        = number
  default     = 2
}

variable "memory" {
  description = "RAM size (e.g., 2G, 4096M)"
  type        = string
  default     = "2G"
}

variable "disk" {
  description = "Disk size (e.g., 30G)"
  type        = string
  default     = "30G"
}

variable "cloud_init" {
  description = "Path to cloud-init file"
  type        = string
  default     = "cloud-init.yaml"
}

