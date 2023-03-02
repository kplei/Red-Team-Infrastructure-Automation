variable "name" {
  type        = string
  description = "Name displayed in AWS"
}

variable "ami" {
  type    = string
  default = "ami-0c7c4e3c6b4941f0f"
}

variable "key_name" {
  default = "<public-key>"
}

variable "domain" {
  type        = string
  description = "Host name for the cert. This can really be anything since cert is self-signed."
}

variable "malleable-c2-profile" {
  type        = string
  default     = "./malleable-c2/jquery-c2.4.5.profile"
  description = "pick one from https://github.com/threatexpress/malleable-c2 or https://github.com/rsmudge/Malleable-C2-Profiles"
}
