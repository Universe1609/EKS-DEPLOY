variable "vpc_id" {
  default = "vpc-0a5c34156ff31df21"
}

variable "subnet_id" {
  #Zona de disponibilidad: us-east-2c
  default = "subnet-092947cf1a14b1a57"
}

variable "name" {
  default = "david"
}

variable "eks_link_private_internal_elb" {
  default = "1"
}

variable "name_eks" {
  description = "La etiqueta asociada debe ser kubernetes.io/cluster/name, donde name es el nombre del cluster a crear"
  default     = "owned" // valor de la etiqueta
}

variable "availability_zone_a" {
  default = "us-east-2a" // Availability Zone A (e.g., use-az1) -
}

variable "availability_zone_b" {
  default = "us-east-2b"
}

variable "eks_link_public_elb" {
  default = "1"
}
