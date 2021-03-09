variable "zone" {
  default = "ch-gva-2"
}

variable "name" {
  default = "kubernetes"
}

variable "kubernetes_version" {
  default = "1.20.2"
}

variable "pools" {
  type = map(map(string))
  default = {
    "pool-1" = { instance_type = "medium", size = 1 },
    "pool-2" = { instance_type = "medium", size = 1 },
    "pool-3" = { instance_type = "medium", size = 1 },
  }
}