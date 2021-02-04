variable "subscription_id" {
  description = "subscription id for remote to azure server"
  default     = ""
  type        = string
  sensitive   = true
}

variable "client_id" {
  description = "client id for remote to azure server"
  default     = ""
  type        = string
  sensitive   = true

}

variable "client_secret" {
  description = "client secret for remote to azure server"
  default     = ""
  type        = string
  sensitive   = true
}

variable "tenant_id" {
  description = "tenant id for remote to azure server"
  default     = ""
  type        = string
  sensitive   = true

}

variable "azure_username" {
  description = "Username for remote to azure server"
  default     = ""
  type        = string
  sensitive   = true
}

variable "azure_password" {
  description = "Password for remote to azure server"
  default     = ""
  type        = string
  sensitive   = true

}