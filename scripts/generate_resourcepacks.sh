#!/bin/bash

##################
# Read constants #
##################

readonly DESCRIPTION=$(cat description.txt)
echo "Description: $DESCRIPTION"

###############################
# Initialize target directory #
###############################

# Make this script fail in case of failed commands
set -ev

# Create empty directory to store files
mkdir -p ./target/
find ./target/ -mindepth 1 -delete

# Create directory for storing resourcepack files
mkdir ./target/resourcepack/

# Copy resourcepack files to maniupulated directory
cp -r ./assets/ ./target/resourcepack/assets/
cp ./pack.png ./target/resourcepack/

############################
# Generate resourcepack V3 #
############################

# Generate multimodel files
python3 ./scripts/generate_multimodels.py --mappings ./mappings/ \
--target ./target/resourcepack/assets/minecraft/models/item/

# Compress JSON models
python3 ./scripts/compress_models.py --models ./target/resourcepack/assets/divinecraft/models/

# Create valid pack.mcmeta
python3 ./scripts/generate_pack_mcmeta.py --path ./target/resourcepack/ --version 3 --description "$DESCRIPTION"

# Generate v3 ZIP-archive
# `cd` is used not to keep full path to files
cd ./target/resourcepack/
zip -r ../resourcepack_v3 .
cd ../../

############################
# Generate resourcepack V4 #
############################

# Fix models
python3 ./scripts/patch_v3_models_to_v4.py --models ./target/resourcepack/assets/divinecraft/models/
python3 ./scripts/patch_v3_models_to_v4.py --models ./target/resourcepack/assets/minecraft/models/

# Create valid pack.mcmeta
python3 ./scripts/generate_pack_mcmeta.py --path ./target/resourcepack/ --version 4 --description "$DESCRIPTION"

# Generate v4 ZIP-archive
# `cd` is used not to keep full path to files
cd ./target/resourcepack/
zip -r ../resourcepack_v4 .
cd ../../
