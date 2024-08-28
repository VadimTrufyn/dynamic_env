
##### ecs fargate
data "aws_ecr_repository" "hello" {
  name = "hello"
}

data "aws_security_group" "web" {
  name = "web"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [ data.aws_vpc.default.id ]
  }
}

data "aws_ecs_cluster" "cluster-1" {
  cluster_name = "cluster-1"
}




data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}


resource "aws_ecs_task_definition" "my_task" {
  for_each = {for pr in var.pr_list : pr => pr }
  family                   = "task-${each.key}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = data.aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = data.aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name      = "py-hello"
    image     = "${data.aws_ecr_repository.hello.repository_url}:${each.key}" # Замініть на ваш образ з ECR
    cpu       = 256
    memory    = 512
    essential = true
    portMappings = [{
      containerPort = 80
      hostPort      = 80
    }]
  }])
}


resource "aws_ecs_service" "my_service" {
  for_each = aws_ecs_task_definition.my_task
  depends_on = [ aws_ecs_task_definition.my_task ]
  name            = "my-ecs-service-${each.key}"
  cluster         = data.aws_ecs_cluster.cluster-1.id
  task_definition = each.value.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets         = data.aws_subnets.default.ids 
    security_groups = [data.aws_security_group.web.id]
    assign_public_ip = true
  }
}
