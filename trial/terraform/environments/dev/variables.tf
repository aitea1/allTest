# 開発環境の変数定義ファイル
# dev環境に特化したパラメータを設定するための変数を定義

variable "region" {
  description = "AWSのリージョン"
  type        = string
  # リソースをデプロイするAWSのリージョン（地理的なデータセンターの場所）
}

variable "environment" {
  description = "環境名"
  type        = string
  default     = "dev"
  # 開発環境を示す識別子。リソース名やタグに使用される
}

# S3バケット関連の変数
variable "bucket_name_prefix" {
  description = "S3バケット名のプレフィックス"
  type        = string
  # バケットの用途を示す名前の接頭辞
}

variable "enable_versioning" {
  description = "バケットのバージョニングを有効にするかどうか"
  type        = bool
  default     = true
  # データ保全のためのバージョン管理機能
}

variable "enable_lifecycle_rules" {
  description = "ライフサイクルルールを有効にするかどうか"
  type        = bool
  default     = false
  # ストレージコスト最適化のための自動データ管理ポリシー
}

variable "expiration_days" {
  description = "オブジェクトの有効期限（日数）"
  type        = number
  default     = 730  # 2年
  # コンプライアンスやコスト管理のためのデータ保持期間設定
}