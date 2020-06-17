#!/bin/bash

# Make this script fail in case of failed commands
set -ev

# Create empty directory to store files
mkdir -p ./target/
find ./target/ -mindepth 1 -delete

# Create directory for storing resourcepack files
mkdir ./target/resourcepack/

# Copy resourcepack files to maniupulated directory
cp ./pack.mcmeta ./target/resourcepack/
cp ./pack.png ./target/resourcepack/
cp -r ./assets/ ./target/resourcepack/assets/

# Generate multimodel files
python ./scripts/generate_multimodels.py

# Compress JSON models

# Generate
cd ./target/resourcepack/
zip -r ../resourcepack .
cd ../../
