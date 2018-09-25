#!/bin/bash
set -euox pipefail

# Download glide

GLIDE_VERSION="0.13.0"
GLIDE_PLATFORM="linux-amd64"
export GIT_CURL_VERBOSE=1
export GIT_SSL_NO_VERIFY=true
export GIT_TRACE_PERFORMANCE=true
echo "My proxies"
echo "http_proxy: "$http_proxy
echo "https_proxy: "$https_proxy

export GlideInstallDir="/tmp/glide/$GLIDE_VERSION"
mkdir -p $GlideInstallDir

if [ ! -f $GlideInstallDir/$GLIDE_PLATFORM/glide ]; then
  URL=https://github.com/Masterminds/glide/releases/download/v${GLIDE_VERSION}/glide-v${GLIDE_VERSION}-linux-amd64.tar.gz

  echo "-----> Download glide ${GLIDE_VERSION}"
  curl -v -s -L --retry 15 --max-time 180 --keepalive-time 240 --retry-delay 2 $URL -o /tmp/glide.tar.gz

  tar xzf /tmp/glide.tar.gz -C $GlideInstallDir
  rm /tmp/glide.tar.gz
fi

export GlideDir=$GlideInstallDir/linux-amd64
if [ ! -f $GlideDir/glide ]; then
  echo "       **ERROR** Could not download glide"
  exit 1
fi
