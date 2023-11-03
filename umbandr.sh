#!/usr/bin/env bash

BINARY_STARTS=9
WORK_DIR=${WORK_DIR:-/tmp}
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH:-/lib64/}:${WORK_DIR}/cascli/"
[ -f "${WORK_DIR}/cascli/cascli" ] || tail -n +$BINARY_STARTS $0|base64 -d|tar -zx -C $WORK_DIR/
exec "${WORK_DIR}/cascli/cascli" "$@"

