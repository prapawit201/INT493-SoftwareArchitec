variable "azure_username" {
  description = "Username for remote to azure server"
  default     = ""
  type        = string
  sensitive   = true
}

variable "azure_password" {
  description = "Password for remtoe to azure server"
  default     = ""
  type        = string
  sensitive   = true

}