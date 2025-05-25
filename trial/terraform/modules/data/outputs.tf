# データストレージモジュールの出力値定義ファイル
# 作成したS3バケットの情報を他のリソースやモジュールで参照できるようにするための出力値

output "bucket_id" {
  description = "作成されたS3バケットのID"
  value       = aws_s3_bucket.data_bucket.id
  # バケットを参照するために使用する基本的な識別子
}

output "bucket_arn" {
  description = "S3バケットのARN"
  value       = aws_s3_bucket.data_bucket.arn
  # IAMポリシーやリソースポリシーで参照するためのAmazon Resource Name
}

output "bucket_domain_name" {
  description = "S3バケットのドメイン名"
  value       = aws_s3_bucket.data_bucket.bucket_domain_name
  # バケットにHTTPリクエストを送信する際のエンドポイントURLを構築するために使用
}

output "bucket_regional_domain_name" {
  description = "S3バケットのリージョナルドメイン名"
  value       = aws_s3_bucket.data_bucket.bucket_regional_domain_name
  # 特定リージョンに最適化されたエンドポイントURLを構築するために使用
}
