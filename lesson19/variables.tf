variable "region" {
  description = "Enter AWS Region" # Appears as an informational message
  default     = "eu-central-1"
}

variable "instance_type" {
  description = "Enter instance type"
  default     = "t2.micro"
}

variable "key_name" {
  description = "Enter key name"
  type        = string
  default     = "Frankfurt-vish"
}

variable "allow_ports" {
  description = "List of ports to open"
  type        = list(any)
  default     = ["80", "443", "22"]
}

variable "enable_detailed_monitoring" {
  description = "Enanle detailed monitoring true/false"
  type        = bool
  default     = false
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(any)
  default = {
    Owner       = "AV"
    Project     = "Variables"
    Environment = "Dev"
  }
}
