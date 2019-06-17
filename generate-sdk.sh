#!/usr/bin/env bash
#
# run the sdk-generator program passing in arguments specific for the specs for this SDK
# note that we can run these commands by using the sdk-generator image as the base image in a specially defined step in the CI
# instead of running this script
#
WORKING_DIR=$PWD
OUTPUT_DIR=$PWD/output
rm -rf ${OUTPUT_DIR} &&
mkdir -p ${OUTPUT_DIR} &&

SERVER=https://api.raincove.io

docker run \
    --volume ${WORKING_DIR}:/app \
    aladdinwealth-docker.jfrog.io/sdk-generator:latest \
    --artifactId raincove-sdk \
    --groupId io.github.erfangc \
    --authorizationServer https://raincove.auth0.com \
    --credentialsFilePath .raincove/credentials.json \
    --inputDirectory /app/public/openapi \
    --apiPackageName io.github.erfangc.raincove.sdk.apis \
    --modelsPackageName io.github.erfangc.raincove.sdk.models \
    --operationsPackageName io.github.erfangc.raincove.sdk.operations \
    --sdkAudience ${SERVER} \
    --sdkClientId t6VkSzjatwn240k31waGW8lhiRjCN6Y4 \
    --sdkName raincove-sdk \
    --sdkOutputDirectory /app/output/raincove-sdk \
    --serviceEndpoint ${SERVER}
