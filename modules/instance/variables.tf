variable "servers" {
  description = "Count of server nodes"
  type        = number
  default     = 1
}

variable "clients" {
  description = "Count of client nodes"
  type        = number
  default     = 1
}

variable "instance_family_image" {
  description = "Instance image"
  type        = string
  default     = "ubuntu-2004-lts"
}

variable "vpc_subnet_id" {
  description = "VPC subnet network id"
  type        = string
}

variable "ssh_credentials" {
  description = "Credentials for connecting to instances"
  type        = object({
    user        = string
    private_key = string
    pub_key     = string
  })
  default     = {
    user        = "ubuntu"
    private_key = "~/.ssh/id_rsa"
    pub_key     = "~/.ssh/id_rsa.pub"
  }
}
