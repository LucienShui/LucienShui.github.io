#!/usr/env/bin bash
# shellcheck shell=bash
# shellcheck disable=SC2216
JPATH='.[0]["assets"][0]["browser_download_url"]'
DOWNLOAD_URL=$(curl -sSL https://api.github.com/repos/LucienShui/i-am-lucien/releases | jq --raw-output "${JPATH}")
PY_CODE="import sys
content = ''.join(sys.stdin.readlines())
lines = content.strip().split('\n')
for i in range(len(lines)):
    if lines[i] == '':
        lines[i] = '    <br/>'
    else:
        lines[i] = '    <p>' + lines[i] + '</p>'
result = '<div id=\"intro\">\n    <h1>Intro</h1>\n' + '\n'.join(lines) + '\n</div>'
print(result)"

wget -O - "${DOWNLOAD_URL}" | tar -xzvf - && \
mv i-am-lucien _site && \
yes | rm _site/page/*example.* && \
cp page/* _site/page/ && \
curl -sSL 'https://raw.githubusercontent.com/LucienShui/epitaph/main/README.md' | python3 -c "${PY_CODE}" > _site/page/intro.html
