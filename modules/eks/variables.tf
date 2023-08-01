variable "cluster_name" {
  default     = "eks"
  type        = string
  description = "AWS EKS CLuster Name"
  nullable    = false
}

variable "iam_role" {
  description = "Role de Iam extraido del modulo IAM"
  type        = string
}

variable "private_a" {
  description = "ID de la subnet privada en la zona a"
}

variable "private_b" {
  description = "ID de la subnet privada en la zona b"
}

variable "public_a" {
  description = "ID de la subnet publica en la zona a"
}

variable "public_b" {
  description = "ID de la subnet publica en la zona b"
}

variable "policy" {
  default = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

variable "iam_role_name" {
  description = "Nombre del rol IAM"
}
