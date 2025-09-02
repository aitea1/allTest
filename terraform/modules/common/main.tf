# Bedrock用のIAMロール
resource "aws_iam_role" "trial_bedrock_execution_role" {
  name = "trial-bedrock-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "bedrock.amazonaws.com"
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = var.aws_account_id
          }
          ArnEquals = {
            "aws:SourceArn" = "arn:aws:bedrock:us-east-1:${var.aws_account_id}:model-invocation-job/*"
          }
        }
      }
    ]
  })
}

# # Bedrock用のS3アクセスポリシー
resource "aws_iam_role_policy" "trial_bedrock_s3_policy" {
  name = "trial-bedrock-s3-policy"
  role = aws_iam_role.trial_bedrock_execution_role.id
  depends_on = [ aws_iam_role.trial_bedrock_execution_role ]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "S3Access"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          "${var.s3_bucket_arn}",
          "${var.s3_bucket_arn}/*",
        ]
        Condition = {
          StringEquals = {
            "aws:ResourceAccount" = [
              var.aws_account_id
            ]
          }
        }
      }
    ]
  })
}

# Lambda用のIAMロール
resource "aws_iam_role" "trial_lambda_bedrock_execution_role" {
  name = "trial-lambda-bedrock-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Bedrock用のモデル呼び出しジョブ作成ポリシー
resource "aws_iam_role_policy" "bedrock_model_invocation_policy" {
  name = "trial-bedrock-model-invocation-policy"
  role = aws_iam_role.trial_lambda_bedrock_execution_role.id
  depends_on = [ aws_iam_role.trial_lambda_bedrock_execution_role, aws_iam_role.trial_bedrock_execution_role ]

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Sid    = "BedrockModelInvocation"
          Effect = "Allow"
          Action = [
            "bedrock:CreateModelInvocationJob"
          ]
          Resource = "*"
        },
        {
          Sid    = "PassRole"
          Effect = "Allow"
          Action = [
            "iam:PassRole"
          ]
          Resource = [
            aws_iam_role.trial_bedrock_execution_role.arn
          ]
        }
      ]
    })
}

# Lambda基本実行ポリシー
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  depends_on = [ aws_iam_role.trial_lambda_bedrock_execution_role ]
  role       = aws_iam_role.trial_lambda_bedrock_execution_role.name
}

# GitHub OIDC用のIAMロール
resource "aws_iam_role" "trial_github_action_bedrock" {
  name = "trial_github_action_bedrock"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${var.aws_account_id}:oidc-provider/token.actions.githubusercontent.com"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:aitea1/allTest:ref:refs/heads/Go-BedrockBatch-Lambda"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "github_action_bedrock_policy_attach" {
  name       = "trial-github-action-bedrock-policy-attach"
  role       = aws_iam_role.trial_github_action_bedrock.name
  depends_on = [ aws_iam_role.trial_github_action_bedrock ]

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "lambda:UpdateFunctionCode",
                "lambda:GetFunction"
            ],
            "Resource": "arn:aws:lambda:us-east-1:${var.aws_account_id}:function:trial-bedrockBatchStart"
        }
    ]
})
}

