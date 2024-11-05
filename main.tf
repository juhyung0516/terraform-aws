resource "aws_ssm_parameter" "foo" {
  name  = "foo"
  type  = "String"
  value = "barr"
  overwrite = true  # 기존 파라미터를 덮어쓰도록 설정
}