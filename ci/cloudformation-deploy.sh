#! /bin/bash

BUCKET_NAME=mkr-tiansen-aws-workshop
STACK_NAME=mkr-tiansen-workshop
HOSTED_ZONE_NAME=tiansen.me
WEB_DOMAIN_NAME=ts.tiansen.me

HOSTED_ZONE=$(aws route53 list-hosted-zones-by-name --dns-name $HOSTED_ZONE_NAME --query "HostedZones[0].Id" --output text)
HOSTED_ZONE_ID=${HOSTED_ZONE: 12}

echo "HOSTED_ZONE_ID: $HOSTED_ZONE_ID"

aws cloudformation deploy \
  --region  us-east-1 \
  --template-file cloudformation-cert.yml \
  --stack-name $STACK_NAME-cert-stack \
  --parameter-overrides \
  "HostedZoneId=$HOSTED_ZONE_ID" \
  "WebDomain=$WEB_DOMAIN_NAME"

CERT_ARN=$(aws cloudformation describe-stacks --region us-east-1 --stack-name $STACK_NAME-cert-stack \
 --query 'Stacks[0].Outputs[?OutputKey==`CertificateArn`].OutputValue' --output text)

echo "CERT_ARN: $CERT_ARN"

aws cloudformation deploy \
  --region  ap-southeast-2 \
  --template-file cloudformation-template.yml \
  --stack-name $STACK_NAME-stack \
  --parameter-overrides \
  "BucketName=$BUCKET_NAME" \
  "HostedZoneId=$HOSTED_ZONE_ID" \
  "WebDomain=$WEB_DOMAIN_NAME" \
  "CertificateArn=$CERT_ARN"
