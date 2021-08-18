#provider "vsphere" {
#  user                 = var.vsphere_user
#  password             = var.vsphere_password
#  vsphere_server       = var.vsphere_server
#  allow_unverified_ssl = true
#  version              = ">= 1.23"
#}
provider "vsphere" {
  user                 = "administrator@vsphere.local"
  password             = "RAPtor1234!"
  vsphere_server       = "172.28.252.60"
  allow_unverified_ssl = true
  version              = ">= 1.23"
}
