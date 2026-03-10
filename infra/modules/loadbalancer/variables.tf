variable "vpc_id" {type = string}

variable "public_subnets" {type = list(string)}

variable "security_group_id" {type = string}

variable "instance_id" {type = string}
variable "certificate_arn" {
  type = string
}
