terraform {
  required_providers {
    kv = {
      source  = "qulia/edu/kv"
    }
  }
}

resource "kv" "test" {
  key   = "TestKey"
  value = "TestValue"
}