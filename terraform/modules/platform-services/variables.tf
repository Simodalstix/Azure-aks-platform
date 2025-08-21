variable "enable_ingress_nginx" {
  description = "Enable NGINX ingress controller"
  type        = bool
  default     = true
}

variable "enable_cert_manager" {
  description = "Enable cert-manager"
  type        = bool
  default     = true
}

variable "enable_external_dns" {
  description = "Enable external-dns"
  type        = bool
  default     = true
}

variable "dns_zone_name" {
  description = "DNS zone name for external-dns"
  type        = string
  default     = ""
}

variable "dns_zone_resource_group" {
  description = "Resource group containing the DNS zone"
  type        = string
  default     = ""
}