#!/usr/bin/env bash

ROOT_PATH=$(cd "$(dirname $0)" && cd ../ && pwd)

aws s3 cp $ROOT_PATH/build s3://mkr-tiansen-aws-workshop \
  --recursive \
  --exclude index.html \
  --cache-control 'public, max-age=31536000'

aws s3 cp $ROOT_PATH/build/index.html s3://mkr-tiansen-aws-workshop \
  --cache-control 'no-cache'