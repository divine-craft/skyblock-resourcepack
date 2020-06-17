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
# Generate resourcepack V2 #
############################

# Generate multimodel files
python3 ./scripts/generate_multimodels.py --mappings ./mappings/ --target ./target/resourcepack/assets/minecraft/items/

# Compress JSON models
python3 ./scripts/compress_models.py --models ./target/resourcepack/assets/divinecraft/models/

# Create valid pack.mcmeta
python3 ./scripts/generate_pack_mcmeta.py --path ./target/resourcepack/ --version 2 --description "$DESCRIPTION"

# Generate v2 ZIP-archive
# `cd` is used not to keep full path to files
cd ./target/resourcepack/
zip -r ../resourcepack_v2 .
cd ../../

############################
# Generate resourcepack V3 #
############################

# Rename minecraft's `items/` folder to `items/` as it contains multimodel files
mv ./target/resourcepack/assets/minecraft/items/ ./target/resourcepack/assets/minecraft/item/

python3 ./scripts/patch_v2_models_to_v3.py --models ./target/resourcepack/assets/divinecraft/models/

# Create valid pack.mcmeta
python3 ./scripts/generate_pack_mcmeta.py --path ./target/resourcepack/ --version 2 --description "$DESCRIPTION"

# Generate v3 ZIP-archive
# `cd` is used not to keep full path to files
cd ./target/resourcepack/
zip -r ../resourcepack_v3 .
cd ../../
