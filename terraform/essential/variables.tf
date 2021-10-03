variable "region" {
  type        = string
  description = "region in aws to store terraform state"
}

variable "region_backup" {
  type        = string
  description = "region in aws where terraform state is replicated"
}

variable "environment_name" {
  type        = string
  description = "prefix resources with environment name"
}

locals {
  # Common tags to be assigned to all resources
  common_tags = {
    Environment = "bestbuy"
  }
}
