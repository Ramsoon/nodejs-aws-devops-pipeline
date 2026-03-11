variable "vpc_id" {type = string}

variable "public_subnets" {type = list(string)}

variable "security_group_id" {type = string}

variable "instance_id" {type = string}
variable "certificate_arn" {
  description = "ARN of SSL certificate to use for HTTPS listener. If null or empty, only an HTTP listener will be created."
  type        = string
  default     = null
}
