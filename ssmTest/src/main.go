package main

import (
	"context"
	"log"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/ssm"
)

// リクエストの構造体
type MyEvent struct {
	ParamName string `json:"param_name"` // リクエスト時にパラメータ名を指定する
}

// レスポンスの構造体
type MyResponse struct {
	ParamValue string `json:"param_value"`
}

// ハンドラー関数
func HandleRequest(ctx context.Context, event MyEvent) (MyResponse, error) {
	// SDK設定のロード
	cfg, err := config.LoadDefaultConfig(ctx)
	if err != nil {
		log.Fatalf("unable to load SDK config, %v", err)
		return MyResponse{}, err
	}

	// SSMクライアントの作成
	ssmClient := ssm.NewFromConfig(cfg)

	// パラメータの取得
	paramInput := &ssm.GetParameterInput{
		Name: aws.String("test"),
	}

	result, err := ssmClient.GetParameter(ctx, paramInput)
	if err != nil {
		log.Printf("failed to get parameter, %v", err)
		return MyResponse{}, err
	}

	log.Printf(*result.Parameter.Value)

	// レスポンスを作成して返す
	return MyResponse{
		ParamValue: *result.Parameter.Value,
	}, nil
}

func main() {
	// Lambdaハンドラーの開始
	lambda.Start(HandleRequest)
}
