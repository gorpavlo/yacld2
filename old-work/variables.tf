variable "flow" {
  type    = string
  default = "24-01"
}

variable "cloud_id" {
  type    = string
  default = "b1g5d3q0835ee8a1i8hk"
}
variable "folder_id" {
  type    = string
  default = "b1gim65ncu3a39v1g0kr"
}

variable "test" {
  type = map(number)
  default = {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }
}
