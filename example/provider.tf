provider "vsphere" {
  user                 = "administrator@vsphere.local"
  password             = "RAPtor1234!"
  vsphere_server       = "172.28.252.60"
  allow_unverified_ssl = true
  version              = ">= 1.23"
}