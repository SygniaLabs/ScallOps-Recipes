#!/bin/bash

# This script is part of the Invisibilitycloak module perobfuscation.
# It reads the new project's name, overwrites pipeline environment variables
# Artifacting 'invisicloak.env' will pass the overwritten variables to the rest of the pipeline's jobs.

# Exchanging old pre-defined values with the new ones
EXE_RELEASE_FOLDER=$(echo $EXE_RELEASE_FOLDER | sed -e "s/$(echo $EXE_FILE_NAME | cut -d "." -f1)/$OBFUSCATED_PROJECT_NAME/g")
EXE_FILE_NAME=$(echo $EXE_FILE_NAME | sed -e "s/$(echo $EXE_FILE_NAME | cut -d "." -f1)/$OBFUSCATED_PROJECT_NAME/g")
CI_PROJECT_SLN_PATH=$(echo $CI_PROJECT_SLN_PATH | sed -e "s/$(basename $CI_PROJECT_SLN_PATH | cut -d "." -f1)/$OBFUSCATED_PROJECT_NAME/g")

# Saving variables to .env file
echo "EXE_RELEASE_FOLDER=$EXE_RELEASE_FOLDER" >> invisicloak.env
echo "EXE_FILE_NAME=$EXE_FILE_NAME" >> invisicloak.env
echo "DOTNET_NAMESPACE=$OBFUSCATED_PROJECT_NAME" >> invisicloak.env    
echo "CI_PROJECT_SLN_PATH=$CI_PROJECT_SLN_PATH" >> invisicloak.env
# Disabling other jobs in the pipeline from downloading the original repo
echo "GIT_STRATEGY=none" >> invisicloak.env