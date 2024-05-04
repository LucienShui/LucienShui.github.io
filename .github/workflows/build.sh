#!/usr/env/bin bash
# shellcheck shell=bash
JPATH='.[0]["assets"][0]["browser_download_url"]'
DOWNLOAD_URL=$(curl -sSL https://api.github.com/repos/LucienShui/i-am-lucien/releases | jq --raw-output "${JPATH}")
wget -O dist.tar.gz "${DOWNLOAD_URL}" && \
tar -xzvf dist.tar.gz && \
mv i-am-lucien _site && \
yes | rm _site/page/*example.* && \
cp page/* _site/page/
