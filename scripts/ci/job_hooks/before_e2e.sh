#!/usr/bin/env bash

FROM=$1;
TO=$2;
PARAMS=$3;

echo "Download artefact from S3 $FROM"
./scripts/ci/utils/artifact-from-s3.sh -a "$FROM" -o "$TO"
echo "Download artefact done"

echo "Replace app.config with options $PARAMS"
node "./scripts/app-config-replace.js" --config="$TO/app.config.json" $PARAMS
echo "Replace app.config done"

echo "====== Update webdriver-manager ====="
if [ "$CI" = "true" ]; then
    export chrome=$(google-chrome --product-version)
    echo "Updating wedriver-manager with chromedriver: $chrome."
    webdriver-manager update --gecko=false --versions.chrome=$chrome
else
    echo "Updating wedriver-manager with latest chromedriver, be sure to use evergreen Chrome."
    webdriver-manager update --gecko=false
fi
