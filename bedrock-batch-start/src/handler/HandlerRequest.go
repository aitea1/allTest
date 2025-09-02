package handler

import (
	"context"
	"fmt"
	"log"
	"os"
	"time"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/bedrock"
	"github.com/aws/aws-sdk-go-v2/service/bedrock/types"
)

func HandlerRequest() {
	// AWS_ACCOUNT_ID環境変数を取得
	awsAccountId := os.Getenv("AWS_ACCOUNT_ID")
	// AWS設定を読み込み
	cfg, err := config.LoadDefaultConfig(context.TODO(),
		config.WithRegion("us-east-1"), // 適切なリージョンに変更してください
	)
	if err != nil {
		log.Fatalf("AWS設定の読み込みに失敗: %v", err)
	}

	// Bedrockクライアントを作成
	client := bedrock.NewFromConfig(cfg)

	// CreateModelInvocationJobの例
	now := time.Now()
	timestamp := now.Format("20060102-150405")
	// job名は同じ名前で作成することができないので、timestampなどつけて動的な名前にしてあげる
	jobName := fmt.Sprintf("bedrock-test-job1-%s", timestamp)

	// 使用したいmodelIDを指定する。AWS Nova Microを利用する際は下記のように指定。
	// 他のmodelIDは公式ドキュメント参照。https://docs.aws.amazon.com/ja_jp/bedrock/latest/userguide/models-supported.html
	modelId := "amazon.nova-micro-v1:0"

	// trial-bedrock-execution-roleのロールarnを指定。
	// AWSAccountIDは公開しない方がいいらしいので環境変数に設定しているが、参考にする人は普通にarnを指定すればOKです。
	roleArn := fmt.Sprintf("arn:aws:iam::%s:role/trial-bedrock-execution-role", awsAccountId)

	// バッチ推論に使う、ファイルのS3URIを指定。
	inputS3Uri := "s3://trial-bedrock-batch-start/trial_bedrock_input.jsonl"
	// バッチ推論の結果を出力するS3URIを指定。
	outputS3Uri := "s3://trial-bedrock-batch-start/"

	input := &bedrock.CreateModelInvocationJobInput{
		JobName: &jobName,
		ModelId: &modelId,
		RoleArn: &roleArn,
		InputDataConfig: &types.ModelInvocationJobInputDataConfigMemberS3InputDataConfig{
			Value: types.ModelInvocationJobS3InputDataConfig{
				S3Uri: &inputS3Uri,
			},
		},
		OutputDataConfig: &types.ModelInvocationJobOutputDataConfigMemberS3OutputDataConfig{
			Value: types.ModelInvocationJobS3OutputDataConfig{
				S3Uri: &outputS3Uri,
			},
		},
	}

	
	result, err := client.CreateModelInvocationJob(context.TODO(), input)
	if err != nil {
		log.Fatalf("CreateModelInvocationJobの実行に失敗: %v", err)
	}

	fmt.Printf("ジョブが正常に作成されました。ジョブARN: %s\n", *result.JobArn)
}
