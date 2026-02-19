variable "project" {
  type        = string
  description = "Project name used for naming resources"
  default     = "tf-guide"
}

variable "env" {
  type        = string
  description = "Deployment environment: dev | staging | prod"
  default     = "dev"
}

variable "aws_region" {
  type        = string
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}
