# Configure the VMware vSphere Provider
provider "vsphere" {
  vsphere_server       = var.vsphere_vcenter
  user                 = var.vsphere_user
  password             = var.vsphere_password
  allow_unverified_ssl = true
}

# Create Datacenter
resource "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

# Create Cluster
resource "vsphere_compute_cluster" "cluster_1" {
  name          = var.vsphere_cluster_1
  datacenter_id = vsphere_datacenter.dc.moid
}

# Add Hosts
resource "vsphere_host" "host_1" {
  hostname = "192.168.30.11"
  username = "root"
  password = var.vsphere_password
  cluster  = vsphere_compute_cluster.cluster_1.id
  force    = true
}

resource "vsphere_host" "host_2" {
  hostname = "192.168.30.12"
  username = "root"
  password = var.vsphere_password
  cluster  = vsphere_compute_cluster.cluster_1.id
  force    = true
}

# Create Cluster 2
resource "vsphere_compute_cluster" "cluster_2" {
  name          = var.vsphere_cluster_2
  datacenter_id = vsphere_datacenter.dc.moid
}

resource "vsphere_host" "host_3" {
  hostname = "192.168.30.13"
  username = "root"
  password = var.vsphere_password
  cluster  = vsphere_compute_cluster.cluster_2.id
  force    = true
}

resource "vsphere_host" "host_4" {
  hostname = "192.168.30.14"
  username = "root"
  password = var.vsphere_password
  cluster  = vsphere_compute_cluster.cluster_2.id
  force    = true
}

resource "vsphere_host" "host_5" {
  hostname = "192.168.30.15"
  username = "root"
  password = var.vsphere_password
  cluster  = vsphere_compute_cluster.cluster_2.id
  force    = true
}

# Build a Server
resource "vsphere_virtual_machine" "server_1" {
  name       = "centos-openstack"
  vcpu       = 2
  memory     = 4096
  domain     = "${var.vm_domain}"
  datacenter = "${var.vsphere_datacenter}"
  cluster    = "${var.vsphere_cluster}"

  # Define the Networking settings for the VM
  network_interface {
    label              = "VM Network"
    ipv4_gateway       = "192.168.30.1"
    ipv4_address       = "192.168.30.215"
    ipv4_prefix_length = "24"
  }

  dns_servers = ["192.168.30.50", "192.168.30.51"]

  # Define the Disks and resources. The first disk should include the template.
  disk {
    template  = "WIN2019-TPL"
    datastore = "Data (1)"
    type      = "thin"
  }

  # Define Time Zone
  time_zone = "America/New_York"
}
