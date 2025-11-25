variable "function_name" {
  type = string
  description = "Lambda function name"
}

variable "function_handler" {
  type        = string
  description = "Entry point that AWS Lambda calls to start your function."
}

variable "filename" {
  type = string
  description = "Zip file that will contain the python code"
}

variable "source_code_hash" {
  type = string
  description = "Used to inform terraform that changes have been made to the python script"
}

variable "environment" {
  type        = string
  description = "Environment name (e.g. staging, preprod, prod)"
}

variable "name" {
  type = string
  description = "Name of the role"
}

variable "policies" {
  type = list(string)
  description = "List of policies to attach to the role"
}

variable "env_vars" {
  type    = map(string)
  default = {}
}