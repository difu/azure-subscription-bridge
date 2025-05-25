variable "location" {
  type = string
  description = "The Azure region"
}

variable "subscription_id" {
  type = string
  description = "The subscription id"
}

variable "tenant_id" {
  type = string
  description = "The tenant id"
}

variable "vm_identity_object_id" {
  type = string
  description = "The identity id of the virtual machine"
}