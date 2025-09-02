package main

import (
	"context"
	"fmt"
	"main/handler"
	"github.com/aws/aws-lambda-go/lambda"
)

func main() {
	lambda.Start(handler.HandlerRequest)
}
