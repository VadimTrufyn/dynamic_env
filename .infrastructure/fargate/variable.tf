variable "region" {
    default = "eu-central-1"
}
variable "ecr_name" {
  default = "hello"
}
variable "ecs_cluster_name" {
  default = "hello"
} 
  
variable "ecs_task_family" {
  default = "hello"
}
variable "ecs_container_name" {
  default = "hello"
}

variable "pr_list" {
  type = list(string)
  default = [ "q2", "q3", "q4", "z3", "z4"]
}

