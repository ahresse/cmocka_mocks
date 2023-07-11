#!/bin/sh -eu

CMD_PATH=$(cd $(dirname $0) && pwd)
BASE_DIR=${CMD_PATH%/*}
PROJECT_NAME=$(basename $BASE_DIR)

echo "remove build directories"
rm -rf \
  "$BASE_DIR/build" \
  "$BASE_DIR/doc/build" \
  "$BASE_DIR/doc/source/generated"
