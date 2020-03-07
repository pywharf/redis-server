#!/bin/bash
set -e

PKG_ROOT=$1
if [[ -z "$PKG_ROOT" ]] ; then
    echo "PKG_ROOT not set."
    exit 1
fi
echo "PKG_ROOT=$PKG_ROOT"

RAW_REDIS_VERSION=$2
if [[ -z "$RAW_REDIS_VERSION" ]] ; then
    echo "RAW_REDIS_VERSION not set."
    exit 1
fi
REDIS_VERSION=${RAW_REDIS_VERSION//-/}  # i.e. 6.0-rc2 => 6.0rc2
echo "REDIS_VERSION=$REDIS_VERSION"

PYTHON_ABI=$3
if [[ -z "$PYTHON_ABI" ]] ; then
    echo "PYTHON_ABI not set."
    exit 1
fi
echo "PYTHON_ABI=$PYTHON_ABI"

PLATFORM_TAG=$4
if [[ -z "$PLATFORM_TAG" ]] ; then
    echo "PLATFORM_TAG not set."
    exit 1
fi
echo "PLATFORM_TAG=$PLATFORM_TAG"

# Build with redis version.
sed -i.bak 's/version = "0.1.0"/version = "'$REDIS_VERSION'"/g' "${PKG_ROOT}/pyproject.toml"
cd $PKG_ROOT && poetry build -f wheel
mv "${PKG_ROOT}/pyproject.toml.bak" "${PKG_ROOT}/pyproject.toml"

# Rename.
POETRY_BUILT_WHL="${PKG_ROOT}/dist/redis_server-${REDIS_VERSION}-py3-none-any.whl"

BUILD_TAG=$(date -u "+%Y%m%d%H%M")
RENAMED_WHL="${PKG_ROOT}/dist/redis_server-${REDIS_VERSION}-${BUILD_TAG}-${PYTHON_ABI}-${PLATFORM_TAG}.whl"
mv $POETRY_BUILT_WHL $RENAMED_WHL
echo $RENAMED_WHL
