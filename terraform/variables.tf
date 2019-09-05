variable "access_token" {
  type = string
  description = "Can be acquired with `gcloud auth print-access-token`"
}

variable "project_id" {
  type = string
  description = "Project's ID"
}

variable "region" {
  type = string
  description = "Project's default region"
}
