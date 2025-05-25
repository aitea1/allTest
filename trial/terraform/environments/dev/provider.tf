# AWSプロバイダと必要なバージョン設定のためのファイル
# Terraformがどのプロバイダ（AWS）を使用し、どのように認証するかを定義

provider "aws" {
  region = var.region  # 環境変数ファイルで指定されたリージョンを使用
}

terraform {
  # 必要なプロバイダとバージョン制約の定義
  # プロジェクトの安定性のため特定のバージョン範囲に制限
  required_providers {
    aws = {
      source  = "hashicorp/aws"  # AWSリソースを管理するためのプロバイダ
      version = "~> 4.0"         # 4.xの最新バージョンを使用
    }
    archive = {
      source  = "hashicorp/archive"  # ZIPファイルなどのアーカイブを作成するためのプロバイダ
      version = "~> 2.0"             # 2.xの最新バージョンを使用
    }
  }
}
