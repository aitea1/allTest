provider "aws" {
  alias  = "bedrock_us-east-1"
  region = "us-east-1"
}

# bedrockBatchStart Lambda関数のプレースホルダー
resource "aws_lambda_function" "bedrock_batch_start_lambda" {
  provider = aws.bedrock_us-east-1

  function_name = "trial-bedrockBatchStart"
  role         = var.lambda_execution_role_arn
  handler      = "bootstrap"
  runtime      = "provided.al2"
  timeout      = 900
  memory_size  = 128

  filename         = "${path.module}/placeholder.zip"
  source_code_hash = data.archive_file.placeholder.output_base64sha256

  environment{
    variables = {
      AWS_ACCOUNT_ID = "${var.aws_account_id}"
    }
  }
}

# プレースホルダーZIPファイル作成
data "archive_file" "placeholder" {
  type        = "zip"
  output_path = "${path.module}/placeholder.zip"
  
  source {
    content  = "package main\n\nimport (\n\t\"context\"\n\t\"github.com/aws/aws-lambda-go/lambda\"\n)\n\nfunc handler(ctx context.Context) (string, error) {\n\treturn \"Hello World from Lambda!\", nil\n}\n\nfunc main() {\n\tlambda.Start(handler)\n}"
    filename = "main.go"
  }
}