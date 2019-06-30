#!/usr/bin/env bash
#
# run the sdk-generator program passing in arguments specific for the specs for this SDK
# note that we can run these commands by using the sdk-generator image as the base image in a specially defined step in the CI
# instead of running this script
#
WORKING_DIR=$PWD
OUTPUT_DIR=/tmp/sdk-generator
rm -rf ${OUTPUT_DIR}
mkdir -p ${OUTPUT_DIR}

SDK_NAME=raincove-sdk
SERVER=https://api.raincove.io
URL=https://github.com/raincove-io

#
# clone the SDK repo
#
git clone ${URL}/${SDK_NAME}.git ${OUTPUT_DIR}/${SDK_NAME}

#
# delete all files except the .git folder
#
cd ${OUTPUT_DIR}/${SDK_NAME}
find . -type d -not -name '.git' -depth 0 -delete
find . -type f -not -name '.git' -depth 0 -delete
cd ${WORKING_DIR}

#
# generate the SDK
#
docker run \
    --volume ${WORKING_DIR}:/app \
    --volume ${OUTPUT_DIR}:${OUTPUT_DIR} \
    erfangc/sdk-generator:latest \
    --artifactId ${SDK_NAME} \
    --groupId io.github.erfangc \
    --authorizationServer https://raincove.auth0.com \
    --credentialsFilePath .raincove/credentials.json \
    --inputDirectory /app/public/openapi \
    --apiPackageName io.github.erfangc.raincove.sdk.apis \
    --modelsPackageName io.github.erfangc.raincove.sdk.models \
    --operationsPackageName io.github.erfangc.raincove.sdk.operations \
    --sdkAudience ${SERVER} \
    --sdkClientId t6VkSzjatwn240k31waGW8lhiRjCN6Y4 \
    --sdkName ${SDK_NAME} \
    --sdkOutputDirectory ${OUTPUT_DIR}/${SDK_NAME} \
    --serviceEndpoint ${SERVER} \
    --url ${URL} \
    --name "Erfang Chen" \
    --email "erfangc@gmail.com" \
    --scmConnection scm:git:git://github.com/raincove-io/${SDK_NAME}.git \
    --scmDeveloperConnection scm:git:git@github.com:raincove-io/${SDK_NAME}.git \
    --scmUrl ${URL}/${SDK_NAME}/tree/master

#
# build and commit the generated SDK back into Git
#
SAVED=$(pwd -P)
cd ${OUTPUT_DIR}/${SDK_NAME}
git config user.name "Erfang Chen"
git config user.email erfangc@gmail.com

mvn -B verify

git add -A && git commit -m "Sync SDK code with API spec" && git push -u origin master

cd ${SAVED}