/* VM deployment test in terraform
We're going to deploy a Win2012R2 linked clone in the VMware Cluster "pCluster" */

variable "vmware_cluster" {
	type = "string"
	default = "pCluster"
	description = "Computing cluster"
}

variable "datacenter" {
	type = "string"
	default = "Homelab"
	description = "Datacenter where we want to deploy the VM"
}

variable "vsphere_user" {
 	type = "string"
	default = "administrator@vsphere.local"
	description = "User we're going to authenticate"
}

variable "vsphere_password" {
	type = "string"
	default = "Password"
}

variable "vsphere_server" {
	type = "string"
	default = "vcenter.vfondevilla.com"
	description = "vCenter we're using"
}

provider "vsphere" {
  user           = "${var.vsphere_user}"
  password       = "${var.vsphere_password}"
  vsphere_server = "${var.vsphere_server}"
  allow_unverified_ssl = "true"
}

# Deploy a virtual machine
resource "vsphere_virtual_machine" "test_win2012_terraform" {
	name = "testwin2012"
	vcpu = 2
	memory = 4096
	cluster = "${var.vmware_cluster}"
	linked_clone = "true"
	domain = "vfondevilla.com"

	windows_opt_config {
		admin_password = "P@ssword1!"
	}


	network_interface {
		label = "2-VM Management"
	}

	disk {
	template = "Template-Windows2012R2"
	datastore = "d01-vm02"
	type = "thin"
	}
}