# 퍼블릭 서브넷 ID 변수 정의
variable "public_subnet_a" {
  description = "The ID of the first public subnet"
  type        = string
}

variable "public_subnet_b" {
  description = "The ID of the second public subnet"
  type        = string
}