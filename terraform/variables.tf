variable "region" {
  default = "us-east-2"
}

variable "key_name" {
  default = "wing-new-key-1"
}

variable "my_ip" {
  description = "Your IP address for SSH access (CIDR format)"
  type        = string
  # Example: "1.2.3.4/32"
}
