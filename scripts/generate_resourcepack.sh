#!/bin/bash

# Make this script fail in case of failed commands
set -ev

# Create empty directory to store files
mkdir -p ./target/
find ./target/ -mindepth 1 -delete

mkdir ./target/resourcepack/

# Copy resourcepack files to `build` directory
cp ./pack.mcmeta ./target/resourcepack/
cp ./pack.png ./target/resourcepack/
cp -r ./assets/ ./target/resourcepack/assets/

cd ./target/resourcepack/
zip -r ../resourcepack .
cd ../../
