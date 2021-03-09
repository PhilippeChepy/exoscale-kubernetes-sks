provider "exoscale" {
  timeout = 120
}

terraform {
  required_providers {
    exoscale = {
      source = "exoscale/exoscale"
    }
  }
  required_version = ">= 0.13"
}