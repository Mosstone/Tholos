#!/usr/bin/env terraform

terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "local" {}

resource "local_file" "test_file" {
  content  = "test\n"
  filename = "output"
}
