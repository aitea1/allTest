# 開発環境の具体的な設定値を定義するファイル
# terraform apply -var-file=dev.tfvars コマンドで使用される

region        = "ap-northeast-1"  # デプロイするAWSリージョン（東京）
environment   = "dev"             # 開発環境を示す識別子

# S3バケット設定
bucket_name_prefix = "trial-s3bucket"  # アプリケーションデータを示すバケット名プレフィックス
enable_versioning = true            # データの変更履歴を保持する機能を有効化
enable_lifecycle_rules = true       # コスト最適化のためのデータ自動移行・削除ポリシーを有効化
expiration_days = 1095              # データを3年間保持し、その後自動削除（コンプライアンス要件）
