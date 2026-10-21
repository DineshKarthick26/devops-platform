variable "cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "region" {
  description = "Region for infra"
  type        = string
  default     = "ap-south-1"
}

variable "name" {
  description = "Tag name"
  type        = string
  default     = "devops-platform"
}

variable "environment" {
  description = "Environment value"
  type        = string
  default     = "app-dev"
}