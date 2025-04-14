variable "key_name" {
  type        = string
  description = "Name of an existing EC2 key pair to allow SSH if needed"
}

variable "image_url" {
  type        = string
  description = "Docker image url"
}
