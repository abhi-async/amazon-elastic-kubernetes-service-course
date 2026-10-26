variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "cluster_name" {
  type    = string
  default = "demo-eks"
}

variable "k8s_version" {
  type        = string
  description = "Kubernetes version. Check the EKS docs for currently supported versions."
  default     = "1.33"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "single_nat_gateway" {
  type        = bool
  description = "true = one shared NAT (cheap, lab). false = one NAT per AZ (HA, production)."
  default     = true
}

variable "endpoint_public_access_cidrs" {
  type        = list(string)
  description = "CIDRs allowed to reach the public API endpoint. Restrict to your IP/VPN."
  default     = ["0.0.0.0/0"]
}

variable "admin_principal_arns" {
  type        = list(string)
  description = "Extra IAM roles/users to grant cluster-admin via EKS access entries."
  default     = []
}

variable "node_instance_types" {
  type    = list(string)
  default = ["t3.medium"]
}

variable "node_desired_size" {
  type    = number
  default = 3
}

variable "node_min_size" {
  type    = number
  default = 1
}

variable "node_max_size" {
  type    = number
  default = 4
}

variable "node_disk_size" {
  type    = number
  default = 30
}

variable "tags" {
  type = map(string)
  default = {
    Project   = "demo-eks"
    ManagedBy = "terraform"
  }
}
