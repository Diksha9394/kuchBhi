terraform {
  backend "gcs" {
      bucket = "fanuep_tfstate"
      prefix = "terraform/state"

  }
}