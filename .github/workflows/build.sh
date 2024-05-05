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
PY_HEAD_CODE="import sys
content = ''.join(sys.stdin.readlines())
lines = content.strip().split('\n')
src = '<meta charset=\"UTF-8\"/>'
dst = \"\"\"<meta charset=\"UTF-8\"/>
    <meta name=\"apple-mobile-web-app-capable\" content=\"yes\">
    <meta name=\"apple-mobile-web-app-status-bar-style\" content=\"black-translucent\">
    <link rel=\"apple-touch-icon\" sizes=\"180x180\" href=\"/assets/img/favicons/apple-touch-icon.png\">
    <link rel=\"icon\" type=\"image/png\" sizes=\"32x32\" href=\"/assets/img/favicons/favicon-32x32.png\">
    <link rel=\"icon\" type=\"image/png\" sizes=\"16x16\" href=\"/assets/img/favicons/favicon-16x16.png\">
    <link rel=\"manifest\" href=\"/assets/img/favicons/site.webmanifest\">
    <link rel=\"shortcut icon\" href=\"/assets/img/favicons/favicon.ico\">
    <meta name=\"apple-mobile-web-app-title\" content=\"I am Lucien\">
    <meta name=\"application-name\" content=\"I am Lucien\">
    <meta name=\"msapplication-TileColor\" content=\"#da532c\">
    <meta name=\"msapplication-config\" content=\"/assets/img/favicons/browserconfig.xml\">
    <meta name=\"theme-color\" content=\"#ffffff\">\"\"\"
print(content.replace(src, dst))
"

wget -O - "${DOWNLOAD_URL}" | tar -xzvf - && \
mv i-am-lucien _site && \
yes | rm _site/page/*example.* && \
cp page/* _site/page/ && \
curl -sSL 'https://raw.githubusercontent.com/LucienShui/epitaph/main/README.md' | python3 -c "${PY_CODE}" > _site/page/intro.html && \
python3 -c "${PY_HEAD_CODE}" < _site/index.html > tmp && \
mv tmp _site/index.html && \
cp -r assets/img _site/assets/
