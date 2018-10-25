#!/usr/bin/env bash

# Create some directories
if [[ ! -d "${VVV_PATH_TO_SITE}/import" ]]; then
    echo "Creating Import directory..."
    mkdir -p ${VVV_PATH_TO_SITE}/import
fi
if [[ ! -d "${VVV_PATH_TO_SITE}/export" ]]; then
    echo "Creating Export directory..."
    mkdir -p ${VVV_PATH_TO_SITE}/export
fi
if [[ ! -d "${VVV_PATH_TO_SITE}/release" ]]; then
    echo "Creating Release directory..."
    mkdir -p ${VVV_PATH_TO_SITE}/release
fi