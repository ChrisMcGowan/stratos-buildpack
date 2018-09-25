#!/bin/bash
set -euox pipefail

# Download dep

DEP_VERSION="0.5.0"
DEP_PLATFORM="linux-amd64"
GIT_CURL_VERBOSE=1
GIT_SSL_NO_VERIFY=true
GIT_TRACE_PERFORMANCE=true
echo "My proxies"
echo "http_proxy: "$http_proxy
echo "https_proxy: "$https_proxy

DOWNLOAD_FOLDER=${CACHE_DIR}/Downloads
mkdir -p ${DOWNLOAD_FOLDER}
DOWNLOAD_FILE=${DOWNLOAD_FOLDER}/dep${DEP_VERSION}

export DepInstallDir="/tmp/dep/$DEP_VERSION"
mkdir -p $DepInstallDir

# Download the file if we do not have it cached
if [ ! -f ${DOWNLOAD_FILE} ]; then
  # Delete any cached dep downloads, since those are now out of date
  rm -rf ${DOWNLOAD_FOLDER}/dep*

  URL=https://github.com/golang/dep/releases/download/v${DEP_VERSION}/dep-${DEP_PLATFORM}
  echo "-----> Download dep ${DEP_VERSION}"
  curl -v -s -L --retry 15 --retry-delay 2 $URL -o ${DOWNLOAD_FILE}
else
  echo "-----> dep install package available in cache"
fi

if [ ! -f $DepInstallDir/dep ]; then
  cp ${DOWNLOAD_FILE} $DepInstallDir/dep
  chmod +x $DepInstallDir/dep
fi

if [ ! -f $DepInstallDir/dep ]; then
  echo "       **ERROR** Could not download dep"
  exit 1
fi
