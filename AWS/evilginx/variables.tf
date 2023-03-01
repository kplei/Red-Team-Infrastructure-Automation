variable "name" {
  type        = string
  description = "Name displayed in AWS"
}

variable "ami" {
  type    = string
  default = "ami-0c7c4e3c6b4941f0f"
}

variable "instance_type" {
  type    = string
  default = "t2.medium"
}

variable "security_group_id" {
  type    = list(any)
  default = ["sg-1", "sg-2"]
}

variable "key_name" {
  default = "public-key"
}
