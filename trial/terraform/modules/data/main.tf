# S3バケットモジュール
# このモジュールは環境ごとのデータ保存用のS3バケットとその設定を管理します

# S3バケットの作成
# アプリケーションデータを保存するためのメインストレージとして機能
resource "aws_s3_bucket" "data_bucket" {
  bucket = "${var.bucket_name_prefix}-${var.environment}-${random_id.suffix.hex}"
  
  tags = {
    Name        = "${var.bucket_name_prefix}-${var.environment}"
    Environment = var.environment
  }
}

# ランダムなサフィックスを生成してバケット名の一意性を確保
# S3バケット名はAWS全体で一意である必要があるため、衝突を防ぐためのランダム文字列を生成
resource "random_id" "suffix" {
  byte_length = 4
}

# バケットのパブリックアクセスをブロック
# セキュリティのため、意図しないパブリックアクセスを防止する設定
resource "aws_s3_bucket_public_access_block" "data_bucket_access" {
  bucket = aws_s3_bucket.data_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# バケットのバージョニング設定
# データ保護のため、オブジェクトの以前のバージョンを保持する機能
# 誤削除や上書きからの復旧が可能になります
resource "aws_s3_bucket_versioning" "data_bucket_versioning" {
  bucket = aws_s3_bucket.data_bucket.id
  
  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Disabled"
  }
}

# ライフサイクルルールの設定（オプション）
# ストレージコスト最適化のための自動データ管理ポリシー
# 時間経過とともにデータをより低コストなストレージクラスに移行し、最終的に削除します
resource "aws_s3_bucket_lifecycle_configuration" "data_bucket_lifecycle" {
  bucket = aws_s3_bucket.data_bucket.id

  rule {
    id     = "archive-and-delete"
    status = var.enable_lifecycle_rules ? "Enabled" : "Disabled"

    transition {
      days          = 90
      storage_class = "STANDARD_IA"  # 90日後にアクセス頻度の低いストレージに移行
    }

    transition {
      days          = 365
      storage_class = "GLACIER"  # 1年後にさらに低コストの長期保存用ストレージに移行
    }

    expiration {
      days = var.expiration_days  # 設定した日数後にオブジェクトを完全に削除
    }
  }
}
