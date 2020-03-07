#!/bin/bash
REDIS_VERSION=$1
if [[ -z "$REDIS_VERSION" ]] ; then
    echo "REDIS_VERSION not set."
    exit 1
fi
echo "REDIS_VERSION=$REDIS_VERSION"

BIN_FOLDER=$2
if [[ -z "$BIN_FOLDER" ]] ; then
    echo "BIN_FOLDER not set."
    exit 1
fi
echo "BIN_FOLDER=$BIN_FOLDER"
mkdir -p $BIN_FOLDER

TMP_DIR=$(mktemp -d)

# Download.
REDIS_RELEASE_URL="http://download.redis.io/releases/redis-${REDIS_VERSION}.tar.gz"
REDIS_RELEASE_SAVE_PATH="${TMP_DIR}/redis.tar.gz"
echo "Download $REDIS_RELEASE_URL and save to $REDIS_RELEASE_SAVE_PATH"
wget -O $REDIS_RELEASE_SAVE_PATH $REDIS_RELEASE_URL

# Decompress.
REDIS_RELEASE_FOLDER="${TMP_DIR}/redis"
mkdir $REDIS_RELEASE_FOLDER
echo "Decompress to $REDIS_RELEASE_FOLDER"
tar -xzf $REDIS_RELEASE_SAVE_PATH -C $REDIS_RELEASE_FOLDER --strip-components=1

# Compile.
make -C $REDIS_RELEASE_FOLDER -j "$(nproc)" all

# Save executables.
REDIS_SERVER_EXEC="${REDIS_RELEASE_FOLDER}/src/redis-server"
$REDIS_SERVER_EXEC --version
echo "Copy $REDIS_SERVER_EXEC to $BIN_FOLDER"
cp $REDIS_SERVER_EXEC $BIN_FOLDER

REDIS_CLI_EXEC="${REDIS_RELEASE_FOLDER}/src/redis-cli"
$REDIS_CLI_EXEC --version
echo "Copy $REDIS_CLI_EXEC to $BIN_FOLDER"
cp $REDIS_CLI_EXEC $BIN_FOLDER

# Cleanup
rm -rf $TMP_DIR
