#!/usr/bin/env bash

#This shell script updates Postman environment file with the API Gateway URL created
# via the api gateway deployment

echo "Running update-clarity-postman-env-file.sh"

api_internal_gateway_url=`aws cloudformation describe-stacks \
   --stack-name pwa-api \
   --query "Stacks[0].Outputs[0].{OutputValueValue:OutputValue}" --output text`

echo "API Gateway URL:" ${api_internal_gateway_url}

jq -e --arg apigwurl "$api_internal_gateway_url" '(.values[] | select(.key=="apigw-root") | .value) = $apigwurl' \
  ClarityAPIEnvironment.postman_environment.json > ClarityAPIEnvironment.postman_environment.json.tmp \
  && cp ClarityAPIEnvironment.postman_environment.json.tmp ClarityAPIEnvironment.postman_environment.json \
  && rm ClarityAPIEnvironment.postman_environment.json.tmp

echo "Updated ClarityAPIEnvironment.postman_environment.json"

cat ClarityAPIEnvironment.postman_environment.json
