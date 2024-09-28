variable "aws_region" {
  description = "aws region to deploy resources"
  type        = string
  default     = "eu-north-1"
}

variable "state_s3_bucket" {
  description = "terraform state s3 bucket"
  type        = string
  default     = "terraform-backend"
}

variable "state_s3_bucket_key" {
  description = "terraform state s3 bucket key"
  type        = string
  default     = "aws-devops/terraform.tfstate"
}

variable "state_dynamodb_table_lock" {
  description = "terraform state dynamodb table for locking"
  type        = string
  default     = "terraform-lock"
}

variable "iam_role_name" {
  description = "iam role name for github actions"
  type        = string
  default     = "GithubActionsRole"
}

variable "github_org" {
  description = "github organization account"
  type        = string
  default     = "IlyaKozak"
}

variable "github_repo" {
  description = "github repo"
  type        = string
  default     = "IlyaKozak"
}

variable "oidc_provider_domain" {
  description = "github actions OIDC domain"
  type        = string
  default     = "token.actions.githubusercontent.com"
}

# https://github.blog/changelog/2023-06-27-github-actions-update-on-oidc-integration-with-aws/
variable "oidc_thumbprint_1" {
  description = "github actions OIDC provider thumbprint 1"
  type        = string
  default     = "6938fd4d98bab03faadb97b34396831e3780aea1"
}

variable "oidc_thumbprint_2" {
  description = "github actions OIDC provider thumbprint 2"
  type        = string
  default     = "1c58a3a8518e8759bf075b76b750d4f2df264fcd"
}