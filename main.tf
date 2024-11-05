resource "aws_ssm_parameter" "foo" {
  name  = "foo"
  type  = "InvalidType"  # 유효하지 않은 값 사용
  value = "barr"
  overwrite = true # 기존 값 덮어쓰기 허용
}