#!/usr/bin/env bash
set -euxo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "${SCRIPT_DIR}"

cp karabiner.json ${HOME}/.config/karabiner/karabiner.json
