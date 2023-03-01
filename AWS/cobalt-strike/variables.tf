variable "name" {
  type = string
  description = "Name displayed in AWS"
}

variable "ami" {
  type    = string
  default = "ami-0c7c4e3c6b4941f0f"
}

variable "key_name" {
  default = "<public-key>"
}

variable "cspw" {
  default = "<teams server password>"
  description = "teams server password"
}

variable "malleable-c2-profile" {
  type    = string
  default = "./maleable-c2-profiles/malleable-c2/jquery-c2.4.5.profile"
  description = "pick one from https://github.com/threatexpress/malleable-c2 or https://github.com/rsmudge/Malleable-C2-Profiles"
}
