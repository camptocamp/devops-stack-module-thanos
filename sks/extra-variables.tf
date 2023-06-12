variable "cluster_id" {
  description = "ID of the SKS cluster."
  type        = string
}

variable "metrics_storage" {
  description = "Exoscale SOS bucket configuration values for the bucket where the archived metrics will be stored."
  type = object({
    bucket_name       = string
    bucket_region     = string
    access_key        = string
    secret_access_key = string
  })
}
