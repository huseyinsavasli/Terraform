locals {
  # These are defaults for each provisionined VM
  # They will apply to every VM unless overwritten for specific VM below
  vm_defaults = {
    guest_id              = "centos7_64Guest"
    name_prefix           = "Batuu-"          # Prefix for all machine names / host names in cluster
    name                  = "Centos7"     # Virtual machine name and host name
    ip                    = "10.10.10.8"      # IP address, use DHCP if null
    datacenter            = "Datacenter"       # Datacenter to provision VM in
    cluster               = "cluster"          # Cluster to provision VM on
    datastore             = "datastore1"       # Datastore to provision VM on
    folder                = "Kubernetes"       # VM Floder to provision VM in
    template              = "Kandy-OS-1"         # VM template path to provision VM from
    network               = "OAM"              # Network to put VM on
    netmask               = 24  # Netmask, if using DHCP can be null
    gateway               = "10.10.10.1"     # Default gateway on the network, if using DHCP can be null
    dns_server_list       = ["172.28.3.10","8.8.8.8"]   # DNS servers to use, if using DHCP can be null
    domain                = "internal"         # Domain of the VM
    dns_suffix_list       = null               # List of search suffixes for DNS
    disk_size             = 50                 # Size (GB) of the disk, can only be greater or equal to the VM tempalte size
    additional_disk_sizes = []                 # Array of sizes (GB) of additional disks to provision
    vcpu                  = 2                  # Number of CPUs
    memory                = 4096               # Memory in Mb
  }

  # Each of node groups are defined here
  vm_list = [
    {
      # Specify this for ansible inventory generation. This will be ansible group name
      ansible_group = "batuu"
      # This is a prefix for vm name and hostname, the actual names will be master1, master2, master3, etc
      name = "admin-"
      # This is a prefix for etcd node name, specify this for ansible inventory generation
      etcd = "etcd"
      # specify individual values for each machine in the group
      # This works with all properies but ansible_group and count, by appending '_array' to the property name
      ip_array = ["172.28.252.34"]


      # More customizations for the group
      memory = 16384
      vcpu = 8
      disk_size = 200
      count  = 1
      network = "OAM"
    },
        {
      ip_array      = ["10.10.10.12", "10.10.10.13"] 
      ansible_group = "app"
      name          = "app-1-"
      memory        = 16384
      vcpu          = 8
      disk_size     = 200
      count         = 2
      network = "BACK"
    },
    {
      ip_array      = ["10.10.10.14", "10.10.10.15"] 
      ansible_group = "api"
      name          = "api-gw-1-"
      memory        = 16384
      vcpu          = 6
      disk_size     = 200
      count         = 2
      network = "BACK"
    },
    {
      ip_array              = ["10.10.10.16", "10.10.10.17"]
      # "192.168.90.98"]
      ansible_group         = "db"
      name                  = "db-1-"
      disk_size             = 200
      memory                = 16384
      vcpu                  = 8
      count                 = 2
      network = "BACK"
    },
        {
      ip_array              = ["10.10.10.11"]
      ansible_group         = "plat"
      name                  = "plat-1-"
      disk_size             = 200
      memory                = 24576
      vcpu                  = 8
      count                 = 1
      network = "BACK"
    },
  ]
}

# Call the module
module "nodes" {
  source      = "github.com/AndrewSav/terraform_vsphere_vm_cluster"
  vm_defaults = local.vm_defaults
  vm_list     = local.vm_list
  # You can specify your own inventory tempalte if you like
  #inventory_template_path = "c:\inventory.tpl"
}

# Write out inventory to a local file
# But you can write it to whereever you want, e.g. Consul, or skip this step alltogether if you do not need inventory
resource "local_file" "inventory" {
  content  = module.nodes.inventory
  filename = "${path.module}/ansible_hosts.ini"
}
