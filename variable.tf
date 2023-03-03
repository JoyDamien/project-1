# variable.tf

variable "my-name" {
  description = "my (the owner)'s name"
  default = "Jieyao"
}

variable "trainer-name" {
  description = "the name of the trainer"
  default = "Ibrahim"
}

variable "trainer-password-init" {
  description = "the initial password for the trainer, which should be changed by the trainer when logging in"
  default = "123456"
}

variable "classmates-name" {
  description = "the name of the classmates"
  default = ["HeeSung", "Shewei", "Ali", "Jarret"]
}

variable "s3-bucket-number" {
  descripion = "the number of s3 bucket"
  default = 2
}