output "lambda_execution_role_arn" {
  description = "Lambda実行用IAMロールのARN"
  value       = aws_iam_role.trial_lambda_bedrock_execution_role.arn
}