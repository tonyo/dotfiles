#!/usr/bin/env bash
set -euxo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "${SCRIPT_DIR}"

cp ${HOME}/.config/karabiner/karabiner.json karabiner.json
