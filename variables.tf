# Company Name
variable "company" {
  type        = string
  description = "This will be used for naming"
}

# azure region
variable "location" {
  type        = string
  description = "Azure region where the resources will be created"
  default     = "West US 2"
}

# victim vnet cidr
variable "offensive-network-vnet-cidr" {
  type        = string
  description = "VNET"
}

# victim vnet cidr
variable "offensive-network-subnet-cidr" {
  type        = string
  description = "Subnet"
}

# SC_EXT private ip
variable "internal-private-ip" {
  type        = string
  description = "Subnet"
}

# username
variable "username" {
  type        = string
  description = "Username"
}

# password
variable "password" {
  type        = string
  description = "Password"
}


