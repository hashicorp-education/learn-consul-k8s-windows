variable "name" {
  description = "Tutorial name"
  type        = string
  default     = "learn-consul-wink8s"
}

variable "vpc_region" {
  type        = string
  description = "The AWS region to create resources in"
  default     = "us-west-2"
}

variable "consul_version" {
  type        = string
  description = "The Consul version"
  default     = "v1.14.4"
}

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

locals {
  name = "${var.name}-${random_string.suffix.result}"
}