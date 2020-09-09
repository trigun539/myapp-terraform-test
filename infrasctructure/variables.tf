variable "profile" {
  type    = string
  default = "default"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.15.0.0/24"
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.15.0.0/27", "10.15.0.32/27"]
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.15.0.64/27", "10.15.0.96/27"]
}

variable "launch_type" {
  type    = string
  default = "FARGATE"
}

variable "fargate_cpu" {
  type    = number
  default = 256
}

variable "fargate_memory" {
  type    = number
  default = 512
}

variable "name" {
  type    = string
  default = "myapp"
}

variable "app_port" {
  type    = number
  default = 80
}

variable "tasks_count" {
  type    = number
  default = 1
}
