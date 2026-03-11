variable "region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = "0.0.0.0/0"
}

variable "docker_image" {
  description = "Docker image for application"
}

variable "domain_name" {
  description = "Domain for SSL certificate"
  default = "credpal.duckdns.org"
}

variable "use_acm" {
  description = "Enable ACM certificate creation/validation"
  type        = bool
  default     = false
}
