#!/usr/bin/env bash
set -euo pipefail

echo "Signing $APP_NAME"

codesign --deep --force --options=runtime --entitlements $ENT --sign $DEVELOPER_HASH --timestamp $APP
