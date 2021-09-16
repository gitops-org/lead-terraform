#General vars
variable "namespace" {}

#Kube-monkey config vars
variable "chart_version" {
  default = "1.4.0"
}
variable "app_version" {
  default = "v0.4.1"
}
variable "run_hour" {
  default = 11
}
variable "start_hour" {
  default = 13
}
variable "end_hour" {
  default = 21
}
variable "timezone" {
  default = "America/New_York"
}
