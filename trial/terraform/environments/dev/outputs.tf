# 既存の出力...

# S3バケット出力
output "s3_bucket_id" {
  description = "作成されたS3バケットのID"
  value       = module.data.bucket_id
}

output "s3_bucket_arn" {
  description = "S3バケットのARN"
  value       = module.data.bucket_arn
}

output "s3_bucket_domain_name" {
  description = "S3バケットのドメイン名"
  value       = module.data.bucket_domain_name
}
