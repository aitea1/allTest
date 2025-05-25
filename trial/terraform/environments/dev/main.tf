# 開発環境のインフラリソース定義ファイル
# 必要なモジュールを呼び出してdev環境のリソースを作成

# S3バケットモジュールを追加
# 開発環境用のデータ保存バケットをセットアップ
module "data" {
  source = "../../modules/data"
  
  environment        = var.environment       # 「dev」環境として設定
  bucket_name_prefix = var.bucket_name_prefix  # バケット名のプレフィックス設定
  enable_versioning  = var.enable_versioning   # バージョニング機能の有効/無効を設定
  enable_lifecycle_rules = var.enable_lifecycle_rules  # ライフサイクルポリシーの有効/無効を設定
  expiration_days    = var.expiration_days     # データ保持期間を設定
}

# 他のモジュールも必要に応じて追加
# 例: コンピューティングリソース、データベース、ネットワークなど
