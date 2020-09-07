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
  default = "10.15.0.0/16"
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
