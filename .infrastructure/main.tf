resource "aws_ecr_repository" "hello" {
  provider    = aws.eu-central-1
  name = var.ecr_name
}

resource "aws_ecr_lifecycle_policy" "retain_images" {
  provider    = aws.eu-central-1
  repository = aws_ecr_repository.hello.name

  policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Retain Dev only the last 3 images",
      "selection": {
        "tagStatus": "any",
        "countType": "imageCountMoreThan",
        "countNumber": 3
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
}