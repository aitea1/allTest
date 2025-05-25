# データストレージモジュールの変数定義ファイル
# S3バケットの設定を外部から制御するためのパラメータを定義

variable "environment" {
  description = "デプロイする環境（dev、staging、prod）"
  type        = string
  # 環境ごとに異なるバケットを作成するための識別子
}

variable "bucket_name_prefix" {
  description = "S3バケット名のプレフィックス"
  type        = string
  # バケットの用途を示す名前の接頭辞。最終的なバケット名は prefix-env-randomsuffix 形式になる
}

variable "enable_versioning" {
  description = "バケットのバージョニングを有効にするかどうか"
  type        = bool
  default     = true
  # データの変更履歴を保持する機能。誤削除や上書きからの復旧に役立つ
}

variable "enable_lifecycle_rules" {
  description = "ライフサイクルルールを有効にするかどうか"
  type        = bool
  default     = false
  # ストレージコスト最適化のための自動データ移行・削除ポリシーを有効化する設定
}

variable "expiration_days" {
  description = "オブジェクトの有効期限（日数）"
  type        = number
  default     = 730  # 2年
  # データ保持期間を設定。コンプライアンス要件やコスト管理に関連
}
